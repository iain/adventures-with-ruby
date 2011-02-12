# encoding: UTF-8
module AdventuresWithRuby
  class Archive < Array

    def initialize
      replace self.class.articles.sort
    end

    def self.articles
      articles = []
      metadata.each do |id, metadata|
        articles << Article.new(id, metadata)
      end
      articles
    end

    def self.metadata
      @metadata ||= YAML.load(File.open(File.expand_path('../index.yml', __FILE__), 'r:utf-8').read)
    end

    def self.find(id)
      Article.new(id, metadata[id])
    end

    def self.dir
      File.expand_path("../../../articles", __FILE__)
    end

  end
end
