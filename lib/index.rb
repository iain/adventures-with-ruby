class IndexReader
end

class NotFoundArticle
  def found?
    false
  end
end

class Index

  def self.find(name)
    new.find(name)
  end

  def initialize(index = nil)
    @index = index
  end

  def find(name)
    index.fetch(name) { NotFoundArticle.new }
  end

  def index
    @index || IndexReader.read
  end

end
