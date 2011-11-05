I think [I've talked about this](/bringing-objects-to-views) before, and there has been a
[Railscasts episode](http://railscasts.com/episodes/101-refactoring-out-helper-object) about it too,
but I want to touch on it again. I know we're supposed to keep views simple, but that doesn't mean
that helpers can only contain methods.

Rails gives you a helper module for every controller. The problem with modules is that they don't
contain state and are usually used to just put a lot of methods in. But this can grow quickly out of
hand when the stuff that you're building is a little more complex.

Never forget to run tools like [Reek](http://wiki.github.com/kevinrutherford/reek/) on your helpers
as well. What do they say? Are your methods too long? Do your methods require too many arguments? Is
the complexity too high? Do your methods have *feature envy*?

I've seen quite a lot of Rails projects and helpers are almost always the forgotten parts of the
application. Every Rails developer knows about the "Skinny Controller, Fat Model"-principle. Better
teams also make skinny models, by using modules and creating macro's. But helpers are usually ugly.
And they shouldn't!

**Helpers are code too! They want your love and dedication!**

There are a couple of ways to keep it clean. Sometimes they are called "Presenter Objects" or
something similar. It doesn't matter how you call them, and you don't have to use any complicated
gems or libraries. Regular classes suffice.

Here's an example of a typical helper:

``` ruby
module PostsHelper

  def post_title(post)
    header_class = post.published? ? "published" : "normal"
    header = content_tag(:h2, post.title, :class => header_class)
    content_tag(:div, :class => "post header") do
      if post.user == current_user
        [ header, edit_post(post), destroy_post(post) ].compact.join(' ')
      else
        header
      end
    end
  end

  def edit_post(post)
    link_to('edit', edit_post_path(post))
  end

  def destroy_post(post)
    link_to('delete', post, :method => :delete, :confirm => "are you sure?")
  end

end
```

You might choose a different route, like putting the `if`-statement in the view. But that's beside
the point. The point is that this is what usually happens when you don't use objects as they are
supposed to be used. Look at the post argument for example. It's on every frickin' method! That's
not <abbr title="Don't Repeat Yourself">DRY</abbr>!

And what if you need to extend it? What if you need approve and reject links as well? What if the
destroy link needs to only show when the post has been approved? It's becoming more and more messy.
Time to refactor!

This is an example of how I would do it:

``` ruby
module PostsHelper

  def post_title(post)
    PostTitle.new(self, post).to_html
  end

  class PostTitle

    attr_initializer :template, :post
    delegate :content_tag, :link_to, :current_user, :to => :template

    def to_html
      content_tag(:div, elements, :class => "post header")
    end

    def elements
      [ header, edit, delete, approve, reject ].compact.join(' ')
    end

    def header
      content_tag(:h2, post.title, :class => header_class)
    end

    def header_class
      post.published? ? "published" : "normal"
    end

    def edit
      link_to('edit', edit_post_path(post)) if my_post?
    end

    def my_post?
      post.user == current_user
    end

    # etc... (you get the drift)

  end

end
```

Nice! Small testable methods! Readable code! Less repetition. *Run Reek on that!*

If you're wondering what the `attr_initializer` is, it's a monkey patch,
that I've [described here](/monkey-patch-of-the-month-attr_initializer). The
[delegate-method](http://apidock.com/rails/Module/delegate) is something ActiveSupport offers you.
Use it, it's super effective!

Wait a minute. Did I say "testable"? Yes, I most certainly did! As with any code, this needs to be
tested. But it's not that hard anymore! If you're using [Rspec](http://rspec.info), you can use the
[helper specs](http://rspec.info/rails/writing/helpers.html) it provides. But you don't need to!

The `PostTitle`-class is a regular Ruby class, and so every test framework can test with it without
much effort. You might want to use stubs and mocks for the other helper methods you call. Or
subclass `PostTitle`, define the used helper methods and use this to subclass in your tests. The
`delegate` specifies which other helper methods are used.

Remember that what you program is entirely up to you. You, and only you, have to decide when a
simple method is enough, or whether you need to add a class, or something similar. You can also
consider using [Builder](http://builder.rubyforge.org/) for some parts, if the HTML generation
becomes too hard.

The main point is that any part of your application needs to receive the same attention to detail.
Don't hide your dead bodies (of code) in helpers, or anywhere! Be critical everywhere and all the
time! Run Reek regularly. It's a depressing tool and you don't need to fix every message every time.
Use it wisely and pay attention. There is **no** excuse for ugly code!

In this example, I would use a partial, but when the view logic increases, you should be thinking
about extracting it.
