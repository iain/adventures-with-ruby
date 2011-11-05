So, about one month ago, I [promised](/monkey-patch-of-the-month-group_by) to share some useful
monkey patches every month. Here is the second one. Your own monkey patches are still more than
welcome!

I often find myself writing code like this:

``` ruby
class Foo
  attr_reader :bar, :baz
  def initialize(bar, baz)
    @bar, @baz = bar, baz
  end
end
```

This can be very annoying to maintain. The variable names are repeated four times, within three lines of code!

Ideally, I'd want to write something like this:

``` ruby
class Foo
  attr_initializer :bar, :baz
end
```

Much better, if you ask me. Here is one example of how to do this.

``` ruby
class Class
  def attr_initializer(*attributes)
    attr_reader *attributes
    class_eval <<-RUBY
      def initialize(#{attributes.join(', ')})
        #{attributes.map{ |attribute| "@#{attribute}" }.join(', ')} = #{attributes.join(', ')}
      end
    RUBY
  end
end
```

No piece of code is complete without tests, so this is it:

``` ruby
class AttrInitializerTests < Test::Unit::TestCase

  def test_attr_initializer
    klass = Class.new do
      attr_initializer :foo, :bar
    end
    object = klass.new(1, 'b')
    assert_equal 1, object.foo
    assert_equal 'b', object.bar
  end

end
```
