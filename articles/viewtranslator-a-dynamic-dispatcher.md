I'm a sucker for syntax. So once again, here's a small experiment. It might not be the most useful snippet out there, but maybe it inspires you to do something awesome. The 'Dynamic Dispatcher' is a common pattern in Ruby. Here I'll demonstrate it to add some syntactic sugar.

In views you can automatically scope translations to the view you're working in.

So this HAML code (in the `users#index` view):

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#e18964">=</font>&nbsp;t(<font color="#336633">'</font><font color="#a8ff60">.foo</font><font color="#336633">'</font>)
</pre>

It's the same as:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#e18964">=</font>&nbsp;t(<font color="#99cc99">:foo</font>, <font color="#99cc99">:scope</font>&nbsp;=&gt; [<font color="#99cc99">:users</font>, <font color="#99cc99">:index</font>])</pre>

I use this technique a lot.

Anyway, we could clean up it even more, by making a dynamic dispatcher. It would look something like this:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#96cbfe">module</font>&nbsp;<font color="#ffffb6">ViewTranslatorHelper</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">vt</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@view_translator</font>&nbsp;||= <font color="#ffffb6">ViewTranslator</font>.new(<font color="#99cc99">self</font>)
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">ViewTranslator</font>&nbsp;&lt; <font color="#ffffb6">ActiveSupport</font>::<font color="#ffffb6">BasicObject</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">initialize</font>(template)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@template</font>&nbsp;= template
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">method_missing</font>(method, options = {})
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ffffb6">ViewTranslator</font>.class_eval &lt;&lt;-<font color="#336633">RUBY</font>
<font color="#a8ff60">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;def </font><font color="#00a0a0">#{</font>method<font color="#00a0a0">}</font><font color="#a8ff60">(options = {})</font>
<font color="#a8ff60">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;@template.t(&quot;.</font><font color="#00a0a0">#{</font>method<font color="#00a0a0">}</font><font color="#a8ff60">&quot;, options)</font>
<font color="#a8ff60">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;end</font>
<font color="#a8ff60">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font><font color="#336633">RUBY</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;__send__(method, options)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">end</font>

<font color="#96cbfe">end</font></pre>

And now you can write:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#e18964">=</font>&nbsp;vt.foo</pre>

### How does this work?

The `vt` method returns `ViewTranslator` instance. It is cached inside an instance variable. The `ViewTranslator` object inherits from `BasicObject` (`ActiveSupport`'s `BasicObject` uses Ruby 1.9 if it is on Ruby 1.9, and constructs it's own when on a lower Ruby version). `BasicObject` is an object that knows no methods, except methods like `__id__` and `__send__`. This makes it ideal for using dynamic dispatchers.

When we define `method_missing` every single method we call on it will be passed to there. We could call `@template.t` directly from here, but we don't. To know why, we must know how `method_missing` works. When you call a method on an object, it looks to see if the object knows the method. When it doesn't know it, it looks to it's superclass and tries again. This happens all the way until it reaches the top of the chain. In Ruby 1.8 that is `Object`, because every object inherits from `Object`. Ruby 1.9 goes one step further and goes to `BasicObject`. If a method is not found anywhere, it will go to the original object you called the method on and it calls `method_missing`. Since that usually isn't there, it goes up the superclass chain until it comes to (`Basic`)`Object`. There it exists. It will raise the exception we all know and hate: `NoMethodError`. You can do this yourself too:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">> "any object".method_missing(:to_s)
NoMethodError: undefined method `to_s' for "any object":String
</pre>

You see, even though the method `to_s` does exist on the string, we stepped halfway in the process of a method call. The error message is a bit confusing, but the we just called a method on the superclass of `String`. Anyway, by defining `method_missing` on our own object, it cuts this chain short. To cut it even shorter, I define the method itself, so it doesn't need to go through this process at all. After it's defined I call the freshly created method.

Now, to be honest. This is not at all that expensive to use method_missing in this case. The chain is only classes long, so it's hardly putting a dent in your performance. There are cases were this is *very* important though. One such case is `ActiveRecord`. When you call a method on a new `ActiveRecord`-object for the first time, you reach `method_missing`. It needs to look at the database to find out if it is an attribute. Looking inside the database is very expensive, so `method_missing` creates methods for all attributes. If the attribute exists, it will be called, and it'll be a normal method call from then on.

Thanks for reading. If you found it informative: I love feedback ;)
