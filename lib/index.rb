class Index

  def self.find(name)
    new.find(name)
  end

  def initialize(index = IndexReader.read, not_found = ArticleNotFound.new)
    @index     = index
    @not_found = not_found
  end

  def find(name)
    @index.fetch(name) { @not_found }
  end

end
