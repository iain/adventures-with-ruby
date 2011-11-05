Of course it's no problem to upgrade from Ruby on Rails 1.2.6 to 2.0.2. Just make sure you don't
fuck up your subversion when unfreezing the old and freezing the new version. I just wanted to have
that out of the way, before starting this new adventure.

My current project (not being the same as the one from [my previous post about the knights
templater](/the-agile-grail-and-the-knights-templater)) in which I totally wrote **123 **views,
of which **48 **partials. Since this project was so Agile, it would have made fucking of the
ugly fat girl from some party look like it had been planned and completely documented months
in advance, it has become a jungle of views rendering partials rendering partials rendering
partials. The HTML had come from the templaters, the functionality is all finished. All we ([Arie
](http://ariekanarie.nl/)and me) need to do now is completely reimplement all the views. Yuck!

[Haml](http://haml-lang.com/) has been
[popping](http://www.relevancellc.com/2008/1/10/help-graeme-make-his-case)
[op](http://antoniocangiano.com/2008/01/08/ramaze-a-ruby-framework-that-will-amaze/)
[often](http://weblog.rubyonrails.com/2007/12/7/rails-2-0-it-s-done)
[lately](http://weblog.rubyonrails.com/2007/7/10/haml-1-7)
[in](http://agilewebdevelopment.com/plugins/haml)
[my](http://www.continuousthinking.com/2007/8/15/agile-conference-2007-day-two) feed reader. It
certainly gets the community talking, but no-one really implements it just yet. I heard [Obie
Fernandez](http://blog.obiefernandez.com/content/2008/01/are-you-using-h.html)'s new company
[HashRocket](http://www.hashrocket.com/) is using it. And since I'm still an intern studying Ruby on
Rails, this seemed the best moment to try it out for real.

But why Haml? Isn't there a faster way? A way to use the HTML done by the templaters? Well, no not
really. Because all templates are more ruby code than HTML anyway. It has more "If I have one object
of this, render that, or else, render that. If you have none of that, replace this with that and
show this message". So much for separating Ruby code from HTML. In this project there is much more
display logic than application logic and although I have about a dozen fully packed helpers, it can
only go so far.

So we had to redo the site anyhow. It would be two weeks of sifting HTML from our old templates and
replacing it with our new templates, putting in the ruby code again. Almost the same as retyping it
all. So if I am going to be retyping it all, I want it to be fast. Let's put Haml to the test!
