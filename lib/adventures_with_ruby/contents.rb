module AdventuresWithRuby
  class Contents < Struct.new(:id)

    def introduction
      remove_images contents_before_first_header
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

    def first_two_paragraphs
      contents_before_first_header.split(/<p/, 3)[0,2].join('<p')
    end

    def contents_before_first_header
      markdown.to_html.split(/<h\d/, 2).first
    end

    def remove_all_but_links(html)
      html.gsub(%r!</?[^a]+((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[^'">\s]+))?)+\s*|\s*)/?>!, '')
    end

    def remove_images(html)
      html.gsub(%r!</?img((\s+\w+(\s*=\s*(?:".*?"|'.*?'|[^'">\s]+))?)+\s*|\s*)/?>!, '')
    end

    def contents
      File.open(File.join(Archive.dir, "#{id}.md"), "r:utf-8").read
    end

  end
end
