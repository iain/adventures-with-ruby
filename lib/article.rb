class Article

  def initialize(attributes)
    @attributes = attributes
  end

  def title
    @attributes["title"]
  end

end
