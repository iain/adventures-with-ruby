You all know `Symbol#to_proc`, right? It allows you to write this:

``` ruby
# Without Symbol#to_proc
[1, 2, 3].map { |it| it.to_s }
[3, 4, 5].inject { |memo, it| memo * it }

# With Symbol#to_proc
[1, 2, 3].map(&:to_s)
[3, 4, 5].inject(&:*)
```

It has been in Rails as long as I can remember, and is in Ruby 1.8.7 and 1.9.x. I love it to death
and I use it everywhere I can.

It is actually quite simple, and you can implement it yourself:

``` ruby
class Symbol
  def to_proc
    Proc.new { |obj, *args| obj.send(self, *args) }
  end
end
```

It works because when you prepend an ampersand (&amp;) to any Ruby object, it calls `#to_proc` to
get a proc to use as block for the method.

What I always regretted though was not being to pass any arguments, so I hacked and monkeypatched a
bit, and got:

``` ruby
class Symbol

  def with(*args, &block)
    @proc_arguments = { :args => args, :block => block }
    self
  end

  def to_proc
    @proc_arguments ||= {}
    args = @proc_arguments[:args] || []
    block = @proc_arguments[:block]
    @proc_arguments = nil
    Proc.new { |obj, *other| obj.send(self, *(other + args), &block) }
  end

end
```

So you can now write:

``` ruby
some_dates.map(&:strftime.with("%d-%M-%Y"))
```

Not that this is any shorter than just creating the darn block in the first place. But hey, it's a
good exercise in metaprogramming and show of more of Ruby's awesome flexibility.

After this I remembered something similar that annoyed me before. It's that Rails helper methods are
just a bag of methods available to, because they are mixed in your template. So if you have an array
of numbers that you want to format as currency, you'd have to do:

``` erb
<%= @prices.map { |price| number_to_currency(price) }.to_sentence %>
```

What if I could apply some `to_proc`-love to that too? All these helper methods cannot be added to
strings, fixnums, and the likes; that would clutter *way* to much. Rather, it might by a nice idea
to use procs that understands helper methods. Here is what I created:

``` ruby
module ProcProxyHelper

  def it(position = 1)
    ProcProxy.new(self, position)
  end

  class ProcProxy

    instance_methods.each { |m| undef_method(m) unless m.to_s =~ /^__|respond_to\?|method_missing/ }

    def initialize(object, position = 1)
      @object, @position = object, position
    end

    def to_proc
      raise "Please specify a method to be called on the object" unless @delegation
      Proc.new { |*values| @object.__send__(*@delegation[:args].dup.insert(@position, *values), &@delegation[:block]) }
    end

    def method_missing(*args, &block)
      @delegation = { :args => args, :block => block }
      self
    end

  end

end
```

I used a clean blank class (in Ruby 1.9, you'd want to inherit it from `BasicObject`), in which I
will provide the proper `proc`-object. I play around with the argument list a bit, handling multiple
arguments and blocks too. You can now use this syntax:

``` erb
<%= @prices.map(&it.number_to_currency).to_sentence %>
```

That is a lot sexier if you as me. And you can use it in any object, not just inside views. And lets
add some extra arguments and some `Enumerator`-love too:

``` ruby
class SomeClass
  include ProcProxyHelper

  def initialize(name, list)
    @name, @list = name, list
  end

  def apply(value, index, seperator)
    "#{@name}, #{index} #{separator} #{value}"
  end

  def applied_list
    @list.map.with_index(&it.apply(":"))
  end

end
```


In case you are wondering, the position you can specify is to tell where the arguments need to go.
Position 0 is the method name, so you shouldn't use that, but any other value is okay. An example
might be that you cant to wrap an array of texts into span-tags:

``` erb
<%= some_texts.map(&it(2).content_tag(:span, :class => "foo")).to_sentence %>
```

So there you have it. I'm probably solving a problem that doesn't exist. It is however a nice
example of the awesome power of Ruby. I hope you've enjoyed this little demonstration of the
possible uses of `to_proc`.
