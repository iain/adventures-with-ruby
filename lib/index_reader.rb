require 'yaml'

class IndexReader

  def self.read(filename = "articles/_index.yml")
    new(filename).read
  end

  def initialize(filename, article = Article)
    @filename = filename
    @article  = article
  end

  def read
    Hash[ load_file.map { |k,v| [ k, @article.new(v) ] } ]
  end

  private

  def load_file
    YAML.load_file(@filename)
  end

end
