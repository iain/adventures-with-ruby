I recently encountered some methods I didn't know about.

### ~

The tilde method (`~`) is used by [Sequel](http://sequel.rubyforge.org/) and you can use it like this:

``` ruby
class Post
  def ~
    11
  end
end

post = Post.new
~post # => 11
```

That's right: you call this method by placing the tilde <strong>before</strong> the object.

In Sequel it is used to perform NOT queries, by defining the tilde on Symbol:

``` ruby
Post.where(~:deleted_at => nil)
# => SELECT * FROM posts WHERE deleted_at IS NOT NULL
```

### -@

The minus-at (`-@`) method works just about the same as the tilde method. It is the method called
when a minus-sign is placed <strong>before</strong> the object. In effect, this means that Fixnum is
implemented somewhere along the lines of this:

``` ruby
class Fixnum
  def -@
    self * -1
  end
end

num = 10
negative = -num # => -10
```

I found this one browsing through the source of the
[`ActiveSupport::Duration`](http://github.com/rails/rails/blob/master/activesupport/lib/active_suppor
t/duration.rb#L34-36) class (you know, the one you get when you do `1.day`). I guess it makes
sense.

Be careful with chaining methods though:

    ruby-1.9.1-p378 > num = 5
     => 5
    ruby-1.9.1-p378 > -num.to_s
    NoMethodError: undefined method `-@' for "5":String
      from (irb):5
      from /Users/iain/.rvm/rubies/ruby-1.9.1-p378/bin/irb:17:in `<main>'

This also applies to the tilde method.

### So?

I don't know. Enrich your DSLs and APIs, if it makes any sense to do it.
