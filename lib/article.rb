class Article

  def initialize(id, attributes)
    @attributes = attributes
  end

  def title
    @attributes["title"]
  end

end
