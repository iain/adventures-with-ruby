require 'tempfile'
require 'nokogiri'

class Code

  def self.parse(code, language)
    new(code, language).to_html.strip
  end

  LANGUAGES = { "ruby" => "rb", "javascript" => "js", "yaml" => "yml" }

  def initialize(code, language)
    fail "Command `mvim` not found" if command_not_found?
    @code = code
    @language = language
  end

  def to_html
    result = ""
    write_code_to_file do |file|
      open_in_macvim file
      send_conversion_to_macvim file do |html|
        result = read_file html
      end
    end
    only_pre_block result
  end

  private

  def command_not_found?
    !system("which mvim > /dev/null")
  end

  def write_code_to_file
    file = Tempfile.new([filename, filename])
    file.puts @code
    file.close
    yield file.path
  ensure
    file.unlink
  end

  def filename
    "code.#{extension}"
  end

  def extension
    LANGUAGES.fetch(@language) { @language }
  end

  def open_in_macvim file
    execute "mvim -n --servername #{servername} --remote-silent #{file}" do
      `mvim --serverlist`.include?(servername)
    end
  end

  def send_conversion_to_macvim(file)
    html = Tempfile.new("html.html")
    html.close
    save_html_to_file html.path
    yield html.path
  ensure
    html.unlink
  end

  def read_file(html)
    File.open(html, 'r:utf-8').read
  end

  def only_pre_block(content)
    Nokogiri::HTML(content).css('pre').first.inner_html
  end

  def save_html_to_file(path)
    execute "mvim --servername #{servername} --remote-send ':set nonumber<CR>:TOhtml<CR>:w! #{path}<CR>:qa!<CR>'" do
      File.open(path).read != ""
    end
  end

  def servername
    @servername ||= "CODEPARSER#{rand(10**20).to_s(36)}".upcase
  end

  def execute(command)
    thread = Thread.new do
      system command
      true until yield
    end
    thread.value
  end

end
