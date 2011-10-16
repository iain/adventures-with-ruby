require 'article_not_found'

class IndexReader
end

class Index

  def self.find(name)
    new.find(name)
  end

  def initialize(index = nil)
    @index = index
  end

  def find(name)
    index.fetch(name) { ArticleNotFound.new }
  end

  def index
    @index || IndexReader.read
  end

end
