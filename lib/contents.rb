class Contents

  @contents = {}

  def self.read(id)
    @contents[id] ||= new(id).read
  end

end
