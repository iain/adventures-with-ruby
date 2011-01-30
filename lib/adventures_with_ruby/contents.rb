module AdventuresWithRuby
  class Contents < Struct.new(:id)

    def introduction
      remove_images contents_before_first_header
    end

    def short
      remove_images first_two_paragraphs
    end

    def html
      RDiscount.new(contents).to_html
    end

    private

    def first_two_paragraphs
      contents_before_first_header.split(/<p/, 3)[0,2].join('<p')
    end

    def contents_before_first_header
      html.split(/<h\d/, 2).first
    end

    def remove_images(html)
      html.gsub(%r!</?img((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[^'">\s]+))?)+\s*|\s*)/?>!, '')
    end

    def contents
      File.open(File.join(Archive.dir, "#{id}.md"), "r:utf-8").read
    end

  end
end
