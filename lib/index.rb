class Index

  def self.find(name)
    new.find(name)
  end

  def initialize(index = nil, reader = IndexReader, not_found = ArticleNotFound.new)
    @index     = index
    @reader    = reader
    @not_found = not_found
  end

  def find(name)
    index.fetch(name) { @not_found }
  end

  def index
    @index || @reader.read
  end

end
