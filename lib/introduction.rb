require 'redcarpet'

class Introduction < Redcarpet::Render::HTML

  def self.read(text)
    md = Redcarpet::Markdown.new(new, :fenced_code_blocks => true)
    md.render(text)
  end

  MARK = "<!-- INTRODUCTION STOPS HERE -->"

  def initialize(*)
    super
    @number_of_paragraphs = 0
  end

  def header(*)
    MARK
  end

  def paragraph(text)
    if @number_of_paragraphs >= 3
      MARK
    elsif text.to_s == ""
      nil
    else
      @number_of_paragraphs += 1
      "<p>#{text}</p>"
    end
  end

  def block_code(*)
    MARK
  end

  def image(*)
    ""
  end

  def postprocess(full_document)
    full_document.split(MARK, 2).first
  end

end
