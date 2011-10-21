require 'redcarpet'

class Body < Redcarpet::Render::HTML

  def self.read(text, code_parser = Code)
    md = Redcarpet::Markdown.new(new(:with_toc_data => true, :hard_wrap => true, :code_parser => code_parser), :fenced_code_blocks => true)
    md.render(text).strip
  end

  def initialize(options)
    @code_parser = options.fetch(:code_parser)
    super
  end

  def block_code(code, language)
    @code_parser.parse(code, language)
  end

end
