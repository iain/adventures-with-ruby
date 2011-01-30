# encoding: UTF-8
module AdventuresWithRuby
  class Article < Struct.new(:file)
    include Comparable

    def <=>(other)
      other.published_at <=> published_at
    end

    def published_at
      metadata['publish']
    end

    def title
      metadata['title']
    end

    def introduction
      remove_images RDiscount.new(contents).to_html.split(/<h\d/, 2).first
    end

    def html
      @html ||= RDiscount.new(contents).to_html
    end

    def found?
      File.exist?(file_name)
    end

    def url
      "/#{file}"
    end

    private

    def remove_images(html)
      html.gsub(%r!</?img((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[^'">\s]+))?)+\s*|\s*)/?>!, '')
    end

    def contents
      contents ||= read.split('---', 2).last
    end

    def metadata
      @metadata ||= YAML.load(read.split('---').first)
    end

    def read
      @read ||= File.read(file_name).encode('utf-8')
    end

    def file_name
      File.join(Archive.dir, "#{file}.md")
    end

  end
end
