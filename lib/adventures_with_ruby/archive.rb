module AdventuresWithRuby
  class Archive < Array

    def initialize
      replace articles
    end

    def articles
      Dir.glob(File.join(self.class.dir, '*.md')).map do |file|
        Article.new(File.basename(file, '.md'))
      end
    end

    def self.find(name)
      Article.new(name)
    end

    def self.dir
      File.expand_path("../../../posts", __FILE__)
    end

  end
end
