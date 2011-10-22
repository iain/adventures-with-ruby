require 'formatting'

class Body < Formatting.body

  def self.read(text, code_parser = Code)
    options = { :with_toc_data => true, :code_parser => code_parser }
    Formatting.format(new(options), text)
  end

  def initialize(options)
    @code_parser = options.fetch(:code_parser)
    super
  end

  def block_code(code, language)
    if language.to_s == ""
      compiled = code
    else
      compiled = @code_parser.parse(code, language)
    end
    "<pre>#{compiled}</pre>"
  end

end
