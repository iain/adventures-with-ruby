require 'introduction'

describe Introduction do

  it "gets the contents before the first header" do
    text = <<-TEXT
First paragraph

Second paragraph

## Header

Third paragraph
    TEXT

    intro(text).should == "<p>First paragraph</p><p>Second paragraph</p>"
  end

  it "removes images" do

    text = <<-TEXT
First paragraph

![alt](image.png)

Second paragraph

## Header

Third paragraph
    TEXT

    intro(text).should == "<p>First paragraph</p><p>Second paragraph</p>"

  end

  it "stops before code blocks" do

    text = <<-TEXT
First paragraph

Second paragraph

```
some code
```

## Header

Third paragraph
    TEXT

    intro(text).should == "<p>First paragraph</p><p>Second paragraph</p>"
  end

  it "limits to three paragraphs" do

    text = <<-TEXT
First paragraph

Second paragraph

Third paragraph

Fourth paragraph
    TEXT

    intro(text).should == "<p>First paragraph</p><p>Second paragraph</p><p>Third paragraph</p>"
  end

  def intro(text)
    Introduction.read(text)
  end

end
