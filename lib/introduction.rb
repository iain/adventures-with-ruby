require 'formatting'

class Introduction < Formatting.introduction

  def self.read(text)
    Formatting.format(new, text)
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
