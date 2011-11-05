This is a translation of [the post I originally wrote down in
Dutch](http://blog.finalist.com/2010/04/12/quest-ce-que-cest-rubyesque/) for my company.

I recently gave a presentation at my company Finalist IT Group about the philosophy behind Ruby.
Code written with this philosophy in mind is called 'Rubyesque'. It's not hard science, so we had
plenty ingredients for a discussion.

The reason behind the presentation was because we're in need of more Ruby developers and looked
inside our own company for Java developers that want to learn Ruby. Because Java and the philosophy
behind it are so radically different from Ruby, we organized a discussion to explore those
differences.

### About programming and the 'flow'

The Rubyesque mindset is all about opinions. Opinions tend to vary from person to person. By reading
a lot of blogs and code I do see some sort of consensus. This opinion is not always explicitly
mentioned, so I don't pretend to speak in absolute truths or be complete.

Programming is usually compared with other professions to give an idea what it's like to do it. Ruby
programmers tend to compare programming with craftsmanship. I even go one step further. I think
programming Ruby is a form of art of playing an instrument. Programming is a creative process.
You're programming to express meaning and intent. The only way to achieve this, is if you know your
instrument so intensely that it's not compromising you're ability to express yourself.

Every programming language has its own style. You can call it its 'flow'.
It's wise to go with the flow. It's easier to use the language as it's
intended to be used than to go against it. For example, don't try to force
[inheritance](http://en.wikipedia.org/wiki/Class-based_programming) in a language that is intended
to be [prototype based](http://en.wikipedia.org/wiki/Prototype-based_programming). Program according
to the flow and other programmers can understand and maintain your code better.

### About Ruby

Everything in Ruby is aimed towards making the programmer happy. A happy programmer is better
motivated to deliver great code and will feel responsible to do so. And better code makes everyone
happy.

It's the machine that is supposed to do the heavy lifting, not the programmer. This means that Ruby
isn't particularly fast, but since machine power is cheaper than man power, it's not that big of a
deal.

Ruby has a couple of traits that make it a joy to work with:

* Dynamic and open to bend it to your liking
* Few rules, so easy to learn
* There are 'shortcuts' for common tasks
* Many ways to reuse code, such as mixins
* Optional punctuation to improve readability
* Methods like [attr_accessor](http://www.rubyist.net/~slagell/ruby/accessors.html) to become more [DRY](http://en.wikipedia.org/wiki/DRY)

### Dynamic

In a dynamic language it's not important to know which type of object you're dealing
with, but it's more important to know what it can do for you. This is called [duck
typing](http://en.wikipedia.org/wiki/Duck_typing). This isn't only handy in making mock object, but
also means that you don't have to abuse inheritance to comply to some method you'd like to call.

A nice example is the Rack specification. The header object you're supposed to return needs to have
the method `each`. It doesn't say that it needs to be a hash. You could use a hash, but if it makes
more in your sense to have some other object, it's fine. You don't have to inherit from hash, just
to implement the `each` method.

The *flow* in Ruby is not to perform any check of the objects. If you're explicitly want an integer,
just call `to_i` inside the method. Any code that checks the type is usually considered to be
distracting from the real meaning of the code. It's the programmer that uses the gem/library
responsibility to use the right objects, and not the responsibility of the gem-maker. The naming of
methods and variables need to be obvious enough, so that it shouldn't be a guessing game.

### Open

In Ruby, nothing is final. This allows for the ability to add and change anything
in any object, including core classes. This is called Monkey Patching or [duck
punching](http://en.wikipedia.org/wiki/Duck_punching). This results in even nicer and more readable
code, like:

``` ruby
15.minutes.ago
```

Nobody needs to explain this. Nobody needs to look up any documents to understand what is going on
here. Monkey patching can improve the readability of the code immensely.

I understand that this technique may be considered extreme by some people. It doesn't comply to the
strict rules that govern most other languages. Still, these kinds of techniques are very handy and
addicting.

Monkey patching is dangerous. It's your own responsibility to use it responsible. Use tests to
ensure that you don't break anything unintentionally.

### Punctuation

Some of Ruby's punctuation is optional. Ruby programmers love to leave them out. It's mostly a
matter of taste. Readability is key here.

Rubyists rather write this:

``` ruby
class Post
  belongs_to :author, :dependent => :destroy
end
```

Than the same code with all punctuation visible:

``` ruby
class Post
  belongs_to(:author, {:dependent => :destroy})
end
```

It's not important that <tt>{:dependent => :destroy}</tt> is a hash. Nor is it important that
`belong_to` is a method, and that it takes two arguments. It's much more important that the post
belongs to an author and that the post will be destroyed when the author is being destroyed.

By not using all the possible punctuation, it becomes easier for our brains to focus on *what* is
actually written, rather that *which objects* might be used to express it.


### Few rules, many shortcuts

There are only a few genuine language constructs. There are just three elements in the language that
have any real meaning. Those are objects, methods and blocks/closures. The only way in which classes
and modules are special is by their implementation, but they are still regular objects. There are
just a few other constructs, most notably `if`, `while` and the logic operators like `&&` and `||`.

The rest of the keywords you see are just shortcuts, you can type to perform common tasks. Like
defining a class:

``` ruby
class Car < Vehicle
  # ...
end
```

The Ruby interpreter reads this as:

``` ruby
Car = Class.new(Vehicle) do
  # ...
end
```

Defining a class is actually just a method called on an object. The first argument is another object
(the class to inherit from) and the second argument is a block. You can write it like this if you
want to and play with it too, like dynamically making many different classes.

Some other examples:

``` ruby
counter += 1           # this is a shortcut
counter = counter + 1  # without the shortcut, but also without punctuation
counter = counter.+(1) # without the shortcut and with all punctuation (yes, + is just a method)
```

``` ruby
@user ||= User.new        # this is called a 'teapot'-operator or 'or-or-equals'
@user = @user || User.new # assign @user to @user if it exists, otherwise create a new user
```

``` ruby
exit unless busy or cancelled  # 'unless' is a shortcut for 'if !()'
exit if !(busy or cancelled)   # 'if' at the end of a sentence is also a shortcut
if !(busy or cancelled)        # for a regular if
  exit
end
```

There are many more shortcuts. But why? Why are there so many ways to do the same thing? It's not
just readability, but also the ease in which you can translate the ideas in your head to code.

The smaller the difference between your thoughts and your code, the easier it is to program. Ruby
gives you full freedom to express yourself how you feel fit. That doesn't mean it always works out.
If you have an unclear image of the problem you're trying to solve, the code you write will be
unclear too. Nothing stops you to write bad code. Ruby doesn't force you in any way. These things
cut both ways.

### Exposing intention

Code needs to expose its intent. Ruby code is Rubyesque if it uses the above mentioned techniques to
expose its intent. Because Ruby has such clean syntax, most DSLs (Domain Specific Languages) will be
written in Ruby. These kinds of DSLs are called internal.

The naming of variables and methods is extremely important. The meaning of the code must be clear
the first time you read it.

A fantastic example is [Rspec](http://rspec.info), my favorite test framework.

``` ruby
describe Post do

  context "when it's not approved" do
    subject { Post.new(:approved => false) }
    it { should_not be_publishable }
  end

  context "when it's approved" do
    subject { Post.new(:approved => true) }
    it { should be_publishable }
  end

end
```

The entire Ruby bag of tricks is being used to make it as natural as possible to write down your
specifications. This example doesn't like like regular Ruby code, but it still is. It's nothing more
than objects, methods and blocks.

This is very Rubyesque. There is almost no distraction from the meaning of the code. I can plainly
read if my code still does what my customer wants and I can run the specs to see if my code does
what I specified it to do. And even nicer: it's incredibly easy! Rspec makes Test Driven Development
very easy.

If you're interested in the code to implement this example, take a look at [this
gist](http://gist.github.com/362030).


### Succinct and Concise

Rubyesque code is succinct. That doesn't just mean short lines (I try to limit myself to
about 80 or 100 characters per line), but also about short methods. The code smell detector
[Reek](http://wiki.github.com/kevinrutherford/reek/) will raise a warning if your method is longer
than 6 lines. Does this means you are not allowed to write longer methods? Of course not. Is it a
good idea? No.

People are better at understanding short sentences. And it's the people that need to understand the
code and maintain. And we're back to the philosophy behind Ruby. It's meant to be understandable for
people. It's less important if the computer needs to do some extra work.

### Conclusion

Ruby is a free language. You can bend the rules. The goal is to make you happy. Ruby was made to
make you happy, to close the gap between human and computer language. Try to do that in the code you
write too, it works!

I found that most people coming from languages like Java or PHP find Ruby a weird or magical
language. That is only the appearance. Ruby is very easy to learn. It has few rules. Ruby
programmers don't code using rigid rules and dogmas, but experiment solving the same problem in
different ways.

I hope you got some idea of what it means to program Rubyesque. I advise everybody to look at the
different languages and their philosophies. See what philosophy suits you. If the Ruby philosophy
suits you and you have the discipline needed to write Ruby, give it a try! Ruby transformed the way
I feel about my job and never regretted learning it one bit.
