module AdventuresWithRuby
  class Article < Struct.new(:file)

    def name
      file.humanize
    end

    def found?
      File.exist?(file_name)
    end

    def file_name
      File.join(Archive.dir, "#{name}.md")
    end

    def url
      "/#{file}"
    end

  end
end
