# encoding: UTF-8
module AdventuresWithRuby
  class Archive < Array
    include Singleton

    def initialize
      replace articles.sort
    end

    def articles
      return @articles if @articles
      @articles = []
      metadata.each do |id, metadata|
        @articles << Article.new(id, metadata)
      end
      @articles
    end

    def metadata
      @metadata ||= YAML.load(File.open(File.join(ROOT, 'index.yml'), 'r:utf-8').read)
    end

    def self.find(id)
      Article.new(id, instance.metadata[id])
    end

  end
end
