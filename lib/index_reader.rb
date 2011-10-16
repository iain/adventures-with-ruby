class IndexReader

  def self.read(filename = "articles/_index.yml")
    new(filename).read
  end

end
