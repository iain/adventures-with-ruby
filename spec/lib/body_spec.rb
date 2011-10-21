require 'body'

describe Body do

  let(:code_parser) { double }

  def body(text)
    Body.read(text, code_parser).gsub("\n", "")
  end

  it "parses simple markdown" do
    text = <<-TEXT

Text

# Header

More Text

    TEXT

    body(text).should == "<p>Text</p><h1 id=\"toc_0\">Header</h1><p>More Text</p>"

  end

  it "handles newlines" do
    text = <<-TEXT
Line 1
Line 2
    TEXT

    body(text).should == "<p>Line 1<br>Line 2</p>"
  end

  it "delegates handling code parsing to the code parser" do
    code_parser.should_receive(:parse).with("the codez\n", "ruby")
    text = <<-TEXT
foo

``` ruby
the codez
```
    TEXT
    body(text)
  end

end
