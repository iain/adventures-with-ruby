require 'formatting'

class TableOfContents < Formatting.toc

  def self.read(text)
    Formatting.format(new, text)
  end

  def initialize(*)
    super
    @headers = []
  end

  def header(text, level)
    if level < 4
      @headers << { "anchor" => "#toc_#{@headers.size}", "title" => text }
    end
    nil
  end

  def postprocess(full_document)
    @headers
  end

end
