require 'redcarpet'
require 'nokogiri'

class TableOfContents

  def self.read(text)
    md  = Redcarpet::Markdown.new(Redcarpet::Render::HTML_TOC.new, :fenced_code_blocks => true)
    doc = Nokogiri::HTML(md.render(text))
    doc.css("a").map { |a| { "anchor" => a[:href], "title" => a.inner_text } }
  end

end
