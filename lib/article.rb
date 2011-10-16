class NotFoundArticle
  def found?
    false
  end
end

class Article

  def self.find(name)
    NotFoundArticle.new
  end

end
