class NotFoundArticle
  def found?
    false
  end
end

class Index

  def self.find(name)
    NotFoundArticle.new
  end

end
