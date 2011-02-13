require './environment'
require 'test/unit'
require 'rack/test'
require 'nokogiri'

set :environment, :test

class SpiderTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    AdventuresWithRuby::Application
  end

  def test_with_spider
    get '/'
    assert last_response.ok?
    assert_has_no_broken_links('/', '/')
  end

  def test_redirect
    get '/2001/09/articles'
    assert last_response.redirect?
  end

  # def test_static
  #   get '/forkme.png'
  #   assert last_response.ok?
  # end

  private

  def assert_has_no_broken_links(page, linked_from)
    history << page
    get page
    assert last_response.ok?, "Link on #{linked_from} broken to #{page} (#{last_response.status})"
    puts "OK: #{page}"
    each_link do |url|
      assert_has_no_broken_links url, page if local?(url)
    end
    # each_img do |url|
    #   get url
    #   assert last_response.ok?, "Image not found on #{linked_from} to #{url} (#{last_response.status})"
    # end
  end

  def each_link
    doc.css('a').each do |link|
      next_page = link[:href]
      yield(next_page) unless history.include?(next_page)
    end
  end

  def each_img
    doc.css('img').each do |link|
      next_page = link[:src]
      yield(next_page) unless history.include?(next_page)
    end
  end

  def doc
    Nokogiri::HTML(last_response.body)
  end

  def local?(link)
    ["/"].include?(link[0])
  end

  def history
    @history ||= []
  end

end
