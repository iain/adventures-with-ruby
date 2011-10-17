class Disqus

  def self.id(id, wp)
    if wp
      "#{wp} http://iain.nl/?p=#{wp}"
    else
      id
    end
  end

end
