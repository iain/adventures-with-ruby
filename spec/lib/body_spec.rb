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

  it "makes code blocks" do
    code_parser.stub(:parse).with("the codez\n", "ruby").and_return("code")
    text = <<-TEXT
``` ruby
the codez
```
    TEXT
    body(text).should == "<pre>code</pre>"
  end

  it "won't parse code blocks without a language" do
    code_parser.should_not_receive(:parse)
    text = <<-TEXT
```
other codez
```
    TEXT
    body(text).should == "<pre>other codez</pre>"
  end

end
