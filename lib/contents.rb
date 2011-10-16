require 'yaml'

class Contents

  def initialize(id, path = "contents")
    @id   = id
    @path = path
  end

  def html
    parsed_yaml.fetch("html")
  end

  def toc
    parsed_yaml.fetch("toc")
  end

  def introduction
    parsed_yaml.fetch("introduction")
  end

  def toc?
    toc.size > 2
  end

  private

  def parsed_yaml
    YAML.load_file(filename)
  end

  def filename
    File.join(@path, "#{@id}.yml")
  end

end
