I'm a sucker for syntax. So once again, here's a small experiment. It might not be the most useful snippet out there, but maybe it inspires you to do something awesome. The 'Dynamic Dispatcher' is a common pattern in Ruby. Here I'll demonstrate it to add some syntactic sugar.

In views you can automatically scope translations to the view you're working in.

So this HAML code (in the `users#index` view):

``` haml
= t('.foo')
```

It's the same as:

``` haml
= t(:foo, :scope => [:users, :index])
```

I use this technique a lot.

Anyway, we could clean up it even more, by making a dynamic dispatcher. It would look something like this:

``` ruby
module ViewTranslatorHelper

  def vt
    @view_translator ||= ViewTranslator.new(self)
  end

  class ViewTranslator < ActiveSupport::BasicObject

    def initialize(template)
      @template = template
    end

    def method_missing(method, options = {})
      ViewTranslator.class_eval <<-RUBY
        def #{method}(options = {})
          @template.t(".#{method}", options)
        end
      RUBY
      __send__(method, options)
    end

  end

end
```

And now you can write:

``` haml
= vt.foo
```

### How does this work?

The `vt` method returns `ViewTranslator` instance. It is cached inside an instance variable. The `ViewTranslator` object inherits from `BasicObject` (`ActiveSupport`'s `BasicObject` uses Ruby 1.9 if it is on Ruby 1.9, and constructs it's own when on a lower Ruby version). `BasicObject` is an object that knows no methods, except methods like `__id__` and `__send__`. This makes it ideal for using dynamic dispatchers.

When we define `method_missing` every single method we call on it will be passed to there. We could call `@template.t` directly from here, but we don't. To know why, we must know how `method_missing` works. When you call a method on an object, it looks to see if the object knows the method. When it doesn't know it, it looks to it's superclass and tries again. This happens all the way until it reaches the top of the chain. In Ruby 1.8 that is `Object`, because every object inherits from `Object`. Ruby 1.9 goes one step further and goes to `BasicObject`. If a method is not found anywhere, it will go to the original object you called the method on and it calls `method_missing`. Since that usually isn't there, it goes up the superclass chain until it comes to (`Basic`)`Object`. There it exists. It will raise the exception we all know and hate: `NoMethodError`. You can do this yourself too:

    > "any object".method_missing(:to_s)
    NoMethodError: undefined method `to_s' for "any object":String

You see, even though the method `to_s` does exist on the string, we stepped halfway in the process of a method call. The error message is a bit confusing, but the we just called a method on the superclass of `String`. Anyway, by defining `method_missing` on our own object, it cuts this chain short. To cut it even shorter, I define the method itself, so it doesn't need to go through this process at all. After it's defined I call the freshly created method.

Now, to be honest. This is not at all that expensive to use method_missing in this case. The chain is only classes long, so it's hardly putting a dent in your performance. There are cases were this is *very* important though. One such case is `ActiveRecord`. When you call a method on a new `ActiveRecord`-object for the first time, you reach `method_missing`. It needs to look at the database to find out if it is an attribute. Looking inside the database is very expensive, so `method_missing` creates methods for all attributes. If the attribute exists, it will be called, and it'll be a normal method call from then on.

Thanks for reading. If you found it informative: I love feedback ;)
