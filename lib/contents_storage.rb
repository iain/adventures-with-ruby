require 'yaml'

class ContentsStorage

  def initialize(id, path = "contents")
    @id   = id
    @path = path
  end

  def filename
    File.join(@path, "#{@id}.yml")
  end

  def read
    @read ||= YAML.load_file(filename)
  end

  def write(contents)
    File.open(filename, 'w:utf-8') { |file| file.write contents.to_yaml }
  end

end
