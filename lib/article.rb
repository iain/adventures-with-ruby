class Article

  attr_reader :id

  def initialize(id, attributes)
    @id         = id
    @attributes = attributes
  end

  def found?
    true
  end

  def title
    @attributes["title"]
  end

  def deprecated?
    @attributes["deprecated"]
  end

  def summary
    @attributes["summary"]
  end

  def published_at
    @attributes["publish"]
  end

  def disqus_id(disqus = Disqus)
    disqus.id(id, @attributes.fetch("wp"))
  end

  def url
    "/#{id}"
  end

  def old?(oldness = Oldness)
    !deprecated? && oldness.old?(@attributes["publish"])
  end

  def contents(contents = Contents)
    @contents ||= contents.new(id)
  end

end
