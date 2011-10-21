class Contents

  def initialize(id, source = ContentsStorage)
    @source = source.new(id).read
  end

  def html
    @source.fetch("html")
  end

  def toc
    @source.fetch("toc")
  end

  def introduction
    @source.fetch("introduction")
  end

  def toc?
    toc.size > 2
  end

end
