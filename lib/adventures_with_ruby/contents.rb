module AdventuresWithRuby
  class Contents < Struct.new(:id)

    def introduction
      remove_images first_three_paragraphs
    end

    def html
      markdown(:generate_toc).to_html
    end

    def toc
      @toc ||= markdown(:generate_toc).toc_content.split(%r!</?li>!).select { |item| item =~ /<a/ }
    end

    def toc?
      toc.size > 2
    end

    private

    def markdown(*extensions)
      @markdown ||= RDiscount.new(contents, *extensions)
    end

    def first_three_paragraphs
      contents_before_code_block.to_s.split(/<\/p>/, 4).take(3).join("</p>")
    end

    def contents_before_code_block
      contents_before_first_header.to_s.split(/<pre/, 2).first
    end

    def contents_before_first_header
      markdown.to_html.split(/<h\d/, 2).first
    end

    def remove_images(html)
      html.gsub(%r!</?img((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[^'">\s]+))?)+\s*|\s*)/?>!, '')
    end

    def contents
      @contents ||= File.open(File.join(ROOT, "articles/#{id}.md"), "r:utf-8").read
    end

  end
end
