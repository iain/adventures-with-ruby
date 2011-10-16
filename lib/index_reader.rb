require 'yaml'

class IndexReader

  def self.read(filename = "articles/_index.yml")
    @read ||= new(filename).read
  end

  def initialize(filename, article = Article)
    @filename = filename
    @article  = article
  end

  def read
    Hash[ load_file.map { |id, attributes| [ id, make_article(id, attributes) ] } ]
  end

  private

  def make_article(id, attributes)
    @article.new(id, attributes)
  end

  def load_file
    YAML.load_file(@filename)
  end

end
