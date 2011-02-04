require 'nokogiri'
require 'active_support'
require 'active_support/core_ext'
require 'open-uri'

module Wordpress

  class Backup

    def document
      Nokogiri::XML(File.read('wordpress.2011-01-30.xml'))
    end

    def items(type = Item)
      document.xpath('//channel/item').map { |item| type.new(item) }.select(&:valid?).reverse
    end

    def index
      index = {}
      items(Post).each do |item|
        index[item.permalink] = item.index
      end
      index
    end

    def posts
      items(Post)
    end

    def images
      items(Image)
    end

  end

  class Item < Struct.new(:item)

    private

    def type
      tag('wp:post_type')
    end

    def tag(tag_name)
      tag = item.xpath(tag_name).first
      tag && tag.content
    end

  end

  class Post < Item

    def title
      tag('title')
    end

    def id
      tag('wp:post_id').to_i
    end

    def index
      { "title" => title, "publish" => publish, "wp" => id }
    end

    def permalink
      tag('wp:post_name')
    end

    def publish
      tag('pubDate').to_date
    end

    def published?
      tag('wp:status') == 'publish'
    end

    def post?
      type == 'post'
    end

    def content
      tag('content:encoded')
    end

    def valid?
      post? and published?
    end

    def save
      File.open("articles/#{permalink}.md", 'w:utf-8') do |f|
        f << content
      end
    end

  end

  class Image < Item

    def valid?
      type == 'attachment'
    end

    def url
      tag('wp:attachment_url')
    end

    def filename
      File.basename(url)
    end

    def file
      open(url)
    end

    def save
      File.open("public/#{filename}", 'wb') do |f|
        f << file.read
      end
      "Attachment saved: #{filename}"
    end

  end

end

backup = Wordpress::Backup.new
# y backup.index
backup.posts.each { |img| p img.save }
