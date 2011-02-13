require './environment'
require 'test/unit'
require 'rack/test'
require 'nokogiri'
require 'net/http'
require 'fileutils'

FileUtils.mkdir_p 'tmp'

set :environment, :test


class SpiderTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def test_with_spider
    spider('/')
  end

  def test_redirect
    get '/2001/09/articles'
    assert_equal 301, last_response.status
  end

  private

  def app
    AdventuresWithRuby::Application
  end

  def spider(page, source = nil)
    history << page
    assert_page   page, source
    assert_images page
    assert_links  page
    puts "OK: #{page}"
  end

  def assert_links(page)
    each_attr :a, :href do |href|
      case
      when href.local?
        spider href, page
      when href.anchor?
        assert last_response.body =~ %r|id=["']#{Regexp.escape(href.sub('#',''))}["']|
      when href.external?
        assert_external_link(href, page)
      when href.mail?
        assert href =~ %r!^mailto:\w+@iain\.nl$!
      else
        flunk "Not a valid url '#{href}' on '#{page}'"
      end
    end
  end

  def assert_page(page, source = nil)
    get page
    assert last_response.ok?, "Link on #{source || '?'} broken to #{page} (#{last_response.status})"
  end

  def assert_images(page)
    each_attr :img, :src do |src|
      if src.local?
        assert File.exist?(File.join(ROOT, "public#{src}")), "Found dead static image '#{src}' on #{page}"
      else
        flunk "On '#{page}', found: '#{src}' is external or not absolute to the root page"
      end
    end
  end

  def each_attr(element, attribute)
    doc.css(element.to_s).each do |link|
      url = link[attribute]
      unless history.include?(url)
        yield(Link.new(url))
      end
    end
  end

  IGNORED_HOSTS = %w|twitter.com workingwithrails.com|
  DISALLOWED_HOSTS = %w|iain.nl infx.nl adventures-with-ruby.com|

  def assert_external_link(link, page)
    unless history.include?(link)
      url = URI.parse(link)
      return if IGNORED_HOSTS.include?(url.host)
      flunk "#{page} is not allowed!" if DISALLOWED_HOSTS.include?(url.host)
      print "Checking external link: #{link} (from #{page})"
      path = url.path == '' ? '/' : url.path
      req = Net::HTTP::Get.new(path)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')
      res = nil
      res = http.start { http.request(req) }
      assert (200..399).include?(res.code.to_i), "Response code was #{res.code} for #{link} (source: #{page})"
      puts " #{res.code.inspect}"
      history << link
    end
  end

  def doc
    Nokogiri::HTML(last_response.body)
  end

  def history
    @history ||= History.new
  end

  def puts(*args)
    File.open("tmp/test.log", "a:utf-8") { |f| f.puts *args }
  end

  def print(*args)
    File.open("tmp/test.log", "a:utf-8") { |f| f.print *args }
  end

  class History

    def links
      @links ||= read
    end

    def <<(url)
      links << url
      if Link.new(url).external?
        write(url)
      end
    end

    def read
      if File.exist?(file)
        YAML.load(File.open(file, 'r:utf-8').read)
      else
        []
      end
    end

    def file
      'test/history.yml'
    end

    def write(url)
      File.open(file, 'a:utf-8') { |f| f.puts %|- "#{url}"| }
    end

    def include?(url)
      links.include?(url)
    end

  end

  class Link < String

    def local?
      first == '/'
    end

    def anchor?
      first == '#'
    end

    def external?
      self =~ %r|^https?://|
    end

    def mail?
      self =~ /^mailto:/
    end

    def first
      split(//,2).first
    end

  end

end
