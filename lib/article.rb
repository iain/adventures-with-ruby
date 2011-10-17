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
    @attributes.fetch("title")
  end

  def deprecated?
    @attributes.fetch("deprecated") { false }
  end

  def summary
    @attributes.fetch("summary")
  end

  def published_at
    @attributes.fetch("publish")
  end

  def disqus_id(disqus = Disqus)
    disqus.id(id, @attributes["wp"])
  end

  def url
    "/#{id}"
  end

  def old?(oldness = Oldness)
    oldness.old?(@attributes.fetch("publish"), deprecated?)
  end

  def contents(contents = Contents)
    @contents ||= contents.new(id)
  end

end
