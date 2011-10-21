require 'table_of_contents'

describe "TOC" do

  it "works" do
    md = <<-MARKDOWN
This is my introduction

### Name Info

More text

### Another header

Even more text
    MARKDOWN
    toc(md).should == [ { "anchor" => "#toc_0", "title" => "Name Info" }, { "anchor" => "#toc_1", "title" => "Another header" } ]
  end

  it "handles many header levels" do
    md = <<-MARKDOWN
This is my introduction

# Name Info

More text

## Another header

Even more text
    MARKDOWN
    toc(md).should == [ { "anchor" => "#toc_0", "title" => "Name Info" }, { "anchor" => "#toc_1", "title" => "Another header" } ]
  end

  it "won't parse headers in code blocks" do
    md = <<-MARKDOWN
This is my introduction

# Name Info

More text

    # this is in a code block

## Another header

``` ruby
# this is code, not a header
```

Even more text
    MARKDOWN
    toc(md).should == [ { "anchor" => "#toc_0", "title" => "Name Info" }, { "anchor" => "#toc_1", "title" => "Another header" } ]
  end

  def toc(text)
    TableOfContents.read(text)
  end

end
