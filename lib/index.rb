require 'article_not_found'

class Index

  def self.find(name)
    new.find(name)
  end

  def initialize(index = nil, reader = IndexReader)
    @index = index
    @reader = reader
  end

  def find(name)
    index.fetch(name) { ArticleNotFound.new }
  end

  def index
    @index || @reader.read
  end

end
