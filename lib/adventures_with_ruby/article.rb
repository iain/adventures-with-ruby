# encoding: UTF-8
module AdventuresWithRuby
  class Article < Struct.new(:id, :metadata)
    include Comparable

    def <=>(other)
      other.published_at <=> published_at
    end

    def published_at
      metadata['publish']
    end

    def disqus_id
      metadata['wp'] ? "#{metadata['wp']} http://iain.nl/?p=#{metadata['wp']}" : id
    end

    def title
      metadata['title']
    end

    def contents
      @contents ||= Contents.new(id)
    end

    def found?
      not metadata.nil?
    end

    def url
      "/#{id}"
    end

  end
end
