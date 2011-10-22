Recently I talked about a [monkey patch called attr_initializer](/monkey-patch-of-the-month-attr_initializer), allowing you to write code like this:

``` ruby
class FooBar
  attr_initializer :foo, :bar
  def to_s
    "your #{foo} is #{bar}"
  end
end

FooBar.new('foo', 'bar')
```

But there is a way of doing it without a monkey patch. Use the [Struct](http://apidock.com/ruby/Struct).

``` ruby
FooBar = Struct.new(:foo, :bar) do
  def to_s
    "your #{foo} is #{bar}"
  end
end

FooBar.new('foo', 'bar')
```

Pretty cool.

<h3>Update</h3>

As was pointed out in my comments by [Radoslav Stankov](http://rstankov.com/) (which you can't see anymore, because I switched to Disqus), you can also do this:

``` ruby
class FooBar < Struct.new(:foo, :bar)
  def to_s
    "your #{foo} is #{bar}"
  end
end

FooBar.new('foo', 'bar')
```

I use this one more often, actually.

One final note: the parameters here aren't stored as instance variables, they can only be accessed through their accessor methods.
