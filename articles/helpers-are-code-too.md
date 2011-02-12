I think [I've talked about this](/bringing-objects-to-views/) before, and there has been a [Railscasts episode](http://railscasts.com/episodes/101-refactoring-out-helper-object) about it too, but I want to touch on it again. I know we're supposed to keep views simple, but that doesn't mean that helpers can only contain methods.

Rails gives you a helper module for every controller. The problem with modules is that they don't contain state and are usually used to just put a lot of methods in. But this can grow quickly out of hand when the stuff that you're building is a little more complex.

Never forget to run tools like [Reek](http://wiki.github.com/kevinrutherford/reek/) on your helpers as well. What do they say? Are your methods too long? Do your methods require too many arguments? Is the complexity too high? Do your methods have *feature envy*?

I've seen quite a lot of Rails projects and helpers are almost always the forgotten parts of the application. Every Rails developer knows about the "Skinny Controller, Fat Model"-principle. Better teams also make skinny models, by using modules and creating macro's. But helpers are usually ugly. And they shouldn't!

**Helpers are code too! They want your love and dedication!**

There are a couple of ways to keep it clean. Sometimes they are called "Presenter Objects" or something similar. It doesn't matter how you call them, and you don't have to use any complicated gems or libraries. Regular classes suffice.

Here's an example of a typical helper:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#96cbfe">module</font>&nbsp;<font color="#ffffb6">PostsHelper</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">post_title</font>(post)
&nbsp;&nbsp;&nbsp;&nbsp;header_class = post.published? ? <font color="#336633">&quot;</font><font color="#a8ff60">published</font><font color="#336633">&quot;</font>&nbsp;: <font color="#336633">&quot;</font><font color="#a8ff60">normal</font><font color="#336633">&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;header = content_tag(<font color="#99cc99">:h2</font>, post.title, <font color="#99cc99">:class</font>&nbsp;=&gt; header_class)
&nbsp;&nbsp;&nbsp;&nbsp;content_tag(<font color="#99cc99">:div</font>, <font color="#99cc99">:class</font>&nbsp;=&gt; <font color="#336633">&quot;</font><font color="#a8ff60">post header</font><font color="#336633">&quot;</font>) <font color="#6699cc">do</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">if</font>&nbsp;post.user == current_user
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[&nbsp;header, edit_post(post), destroy_post(post) ].compact.join(<font color="#336633">'</font><font color="#a8ff60">&nbsp;</font><font color="#336633">'</font>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">else</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;header
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">end</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">end</font>
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">edit_post</font>(post)
&nbsp;&nbsp;&nbsp;&nbsp;link_to(<font color="#336633">'</font><font color="#a8ff60">edit</font><font color="#336633">'</font>, edit_post_path(post))
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">destroy_post</font>(post)
&nbsp;&nbsp;&nbsp;&nbsp;link_to(<font color="#336633">'</font><font color="#a8ff60">delete</font><font color="#336633">'</font>, post, <font color="#99cc99">:method</font>&nbsp;=&gt; <font color="#99cc99">:delete</font>, <font color="#99cc99">:confirm</font>&nbsp;=&gt; <font color="#336633">&quot;</font><font color="#a8ff60">are you sure?</font><font color="#336633">&quot;</font>)
&nbsp;&nbsp;<font color="#96cbfe">end</font>

<font color="#96cbfe">end</font></pre>

You might choose a different route, like putting the `if`-statement in the view. But that's beside the point. The point is that this is what usually happens when you don't use objects as they are supposed to be used. Look at the post argument for example. It's on every frickin' method! That's not <abbr title="Don't Repeat Yourself">DRY</abbr>!

And what if you need to extend it? What if you need approve and reject links as well? What if the destroy link needs to only show when the post has been approved? It's becoming more and more messy. Time to refactor!

This is an example of how I would do it:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#96cbfe">module</font>&nbsp;<font color="#ffffb6">PostsHelper</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">post_title</font>(post)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ffffb6">PostTitle</font>.new(<font color="#99cc99">self</font>, post).to_html
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">PostTitle</font>

&nbsp;&nbsp;&nbsp;&nbsp;attr_initializer <font color="#99cc99">:template</font>, <font color="#99cc99">:post</font>
&nbsp;&nbsp;&nbsp;&nbsp;delegate <font color="#99cc99">:content_tag</font>, <font color="#99cc99">:link_to</font>, <font color="#99cc99">:current_user</font>, <font color="#99cc99">:to</font>&nbsp;=&gt; <font color="#99cc99">:template</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">to_html</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;content_tag(<font color="#99cc99">:div</font>, elements, <font color="#99cc99">:class</font>&nbsp;=&gt; <font color="#336633">&quot;</font><font color="#a8ff60">post header</font><font color="#336633">&quot;</font>)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">elements</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;[&nbsp;header, edit, delete, approve, reject ].compact.join(<font color="#336633">'</font><font color="#a8ff60">&nbsp;</font><font color="#336633">'</font>)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">header</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;content_tag(<font color="#99cc99">:h2</font>, post.title, <font color="#99cc99">:class</font>&nbsp;=&gt; header_class)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">header_class</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;post.published? ? <font color="#336633">&quot;</font><font color="#a8ff60">published</font><font color="#336633">&quot;</font>&nbsp;: <font color="#336633">&quot;</font><font color="#a8ff60">normal</font><font color="#336633">&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">edit</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;link_to(<font color="#336633">'</font><font color="#a8ff60">edit</font><font color="#336633">'</font>, edit_post_path(post)) <font color="#6699cc">if</font>&nbsp;my_post?
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">my_post?</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;post.user == current_user
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># etc... (you get the drift)</font>

&nbsp;&nbsp;<font color="#96cbfe">end</font>

<font color="#96cbfe">end</font></pre>

Nice! Small testable methods! Readable code! Less repetition. *Run Reek on that!*

If you're wondering what the `attr_initializer` is, it's a monkey patch, that I've [described here](/monkey-patch-of-the-month-attr_initializer/). The [delegate-method](http://apidock.com/rails/Module/delegate) is something ActiveSupport offers you. Use it, it's super effective!

Wait a minute. Did I say "testable"? Yes, I most certainly did! As with any code, this needs to be tested. But it's not that hard anymore! If you're using [Rspec](http://rspec.info), you can use the [helper specs](http://rspec.info/rails/writing/helpers.html) it provides. But you don't need to!

The `PostTitle`-class is a regular Ruby class, and so every test framework can test with it without much effort. You might want to use stubs and mocks for the other helper methods you call. Or subclass `PostTitle`, define the used helper methods and use this to subclass in your tests. The `delegate` specifies which other helper methods are used.

Remember that what you program is entirely up to you. You, and only you, have to decide when a simple method is enough, or whether you need to add a class, or something similar. You can also consider using [Builder](http://builder.rubyforge.org/) for some parts, if the HTML generation becomes too hard.

The main point is that any part of your application needs to receive the same attention to detail. Don't hide your dead bodies (of code) in helpers, or anywhere! Be critical everywhere and all the time! Run Reek regularly. It's a depressing tool and you don't need to fix every message every time. Use it wisely and pay attention. There is **no** excuse for ugly code!

In this example, I would use a partial, but when the view logic increases, you should be thinking about extracting it.
