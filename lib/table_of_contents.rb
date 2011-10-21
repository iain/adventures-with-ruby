require 'redcarpet'

class TableOfContents < Redcarpet::Render::Base

  def self.read(text)
    md  = Redcarpet::Markdown.new(new, :fenced_code_blocks => true)
    md.render(text)
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
