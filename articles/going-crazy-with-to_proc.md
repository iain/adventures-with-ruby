You all know `Symbol#to_proc`, right? It allows you to write this:

<pre class="ir_black"><font color="#7c7c7c"># Without Symbol#to_proc</font>
[<font color="#ff73fd">1</font>, <font color="#ff73fd">2</font>, <font color="#ff73fd">3</font>].map { |<font color="#c6c5fe">it</font>|&nbsp;it.to_s }
[<font color="#ff73fd">3</font>, <font color="#ff73fd">4</font>, <font color="#ff73fd">5</font>].inject { |<font color="#c6c5fe">memo</font>, <font color="#c6c5fe">it</font>|&nbsp;memo * it }

<font color="#7c7c7c"># With Symbol#to_proc</font>
[<font color="#ff73fd">1</font>, <font color="#ff73fd">2</font>, <font color="#ff73fd">3</font>].map(&amp;<font color="#99cc99">:to_s</font>)
[<font color="#ff73fd">3</font>, <font color="#ff73fd">4</font>, <font color="#ff73fd">5</font>].inject(&amp;<font color="#99cc99">:*</font>)</pre>

It has been in Rails as long as I can remember, and is in Ruby 1.8.7 and 1.9.x. I love it to death and I use it everywhere I can.

It is actually quite simple, and you can implement it yourself:

<pre class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Symbol</font>
&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">to_proc</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ffffb6">Proc</font>.new { |<font color="#c6c5fe">obj</font>, *<font color="#c6c5fe">args</font>|&nbsp;obj.send(<font color="#99cc99">self</font>, *args) }
&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font></pre>

It works because when you prepend an ampersand (&amp;) to any Ruby object, it calls `#to_proc` to get a proc to use as block for the method.

What I always regretted though was not being to pass any arguments, so I hacked and monkeypatched a bit, and got:

<pre class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Symbol</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">with</font>(*args, &amp;block)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@proc_arguments</font>&nbsp;= { <font color="#99cc99">:args</font>&nbsp;=&gt; args, <font color="#99cc99">:block</font>&nbsp;=&gt; block }
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#99cc99">self</font>
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">to_proc</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@proc_arguments</font>&nbsp;||= {}
&nbsp;&nbsp;&nbsp;&nbsp;args = <font color="#c6c5fe">@proc_arguments</font>[<font color="#99cc99">:args</font>] || []
&nbsp;&nbsp;&nbsp;&nbsp;block = <font color="#c6c5fe">@proc_arguments</font>[<font color="#99cc99">:block</font>]
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@proc_arguments</font>&nbsp;= <font color="#99cc99">nil</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ffffb6">Proc</font>.new { |<font color="#c6c5fe">obj</font>, *<font color="#c6c5fe">other</font>|&nbsp;obj.send(<font color="#99cc99">self</font>, *(other + args), &amp;block) }
&nbsp;&nbsp;<font color="#96cbfe">end</font>

<font color="#96cbfe">end</font></pre>

So you can now write:

<pre class="ir_black">some_dates.map(&amp;<font color="#99cc99">:strftime</font>.with(<font color="#336633">&quot;</font><font color="#a8ff60">%d-%M-%Y</font><font color="#336633">&quot;</font>))</pre>

Not that this is any shorter than just creating the darn block in the first place. But hey, it's a good exercise in metaprogramming and show of more of Ruby's awesome flexibility.

After this I remembered something similar that annoyed me before. It's that Rails helper methods are just a bag of methods available to, because they are mixed in your template. So if you have an array of numbers that you want to format as currency, you'd have to do:

<pre class="ir_black"><font color="#00a0a0">&lt;%=</font>&nbsp;<font color="#c6c5fe">@prices</font>.map { |<font color="#c6c5fe">price</font>|&nbsp;number_to_currency(price) }.to_sentence <font color="#00a0a0">%&gt;</font></pre>

What if I could apply some `to_proc`-love to that too? All these helper methods cannot be added to strings, fixnums, and the likes; that would clutter *way* to much. Rather, it might by a nice idea to use procs that understands helper methods. Here is what I created:

<pre class="ir_black"><font color="#96cbfe">module</font>&nbsp;<font color="#ffffb6">ProcProxyHelper</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">it</font>(position = <font color="#ff73fd">1</font>)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ffffb6">ProcProxy</font>.new(<font color="#99cc99">self</font>, position)
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">ProcProxy</font>

&nbsp;&nbsp;&nbsp;&nbsp;instance_methods.each { |<font color="#c6c5fe">m</font>|&nbsp;undef_method(m) <font color="#6699cc">unless</font>&nbsp;m.to_s =~ <font color="#ff8000">/</font><font color="#e18964">^</font><font color="#b18a3d">__</font><font color="#e18964">|</font><font color="#b18a3d">respond_to</font><font color="#e18964">\?</font><font color="#e18964">|</font><font color="#b18a3d">method_missing</font><font color="#ff8000">/</font>&nbsp;}

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">initialize</font>(object, position = <font color="#ff73fd">1</font>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@object</font>, <font color="#c6c5fe">@position</font>&nbsp;= object, position
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">to_proc</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">raise</font>&nbsp;<font color="#336633">&quot;</font><font color="#a8ff60">Please specify a method to be called on the object</font><font color="#336633">&quot;</font>&nbsp;<font color="#6699cc">unless</font>&nbsp;<font color="#c6c5fe">@delegation</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#ffffb6">Proc</font>.new { |*<font color="#c6c5fe">values</font>|&nbsp;<font color="#c6c5fe">@object</font>.__send__(*<font color="#c6c5fe">@delegation</font>[<font color="#99cc99">:args</font>].dup.insert(<font color="#c6c5fe">@position</font>, *values), &amp;<font color="#c6c5fe">@delegation</font>[<font color="#99cc99">:block</font>]) }
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">method_missing</font>(*args, &amp;block)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@delegation</font>&nbsp;= { <font color="#99cc99">:args</font>&nbsp;=&gt; args, <font color="#99cc99">:block</font>&nbsp;=&gt; block }
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#99cc99">self</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">end</font>

<font color="#96cbfe">end</font></pre>

I used a clean blank class (in Ruby 1.9, you'd want to inherit it from `BasicObject`), in which I will provide the proper `proc`-object. I play around with the argument list a bit, handling multiple arguments and blocks too. You can now use this syntax:

<pre class="ir_black"><font color="#00a0a0">&lt;%=</font>&nbsp;<font color="#c6c5fe">@prices</font>.map(&amp;it.number_to_currency).to_sentence <font color="#00a0a0">%&gt;</font></pre>


That is a lot sexier if you as me. And you can use it in any object, not just inside views. And lets add some extra arguments and some `Enumerator`-love too:

<pre class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">SomeClass</font>
&nbsp;&nbsp;<font color="#96cbfe">include</font>&nbsp;<font color="#ffffb6">ProcProxyHelper</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">initialize</font>(name, list)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@name</font>, <font color="#c6c5fe">@list</font>&nbsp;= name, list
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">apply</font>(value, index, seperator)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#336633">&quot;</font><font color="#00a0a0">#{</font><font color="#c6c5fe">@name</font><font color="#00a0a0">}</font><font color="#a8ff60">, </font><font color="#00a0a0">#{</font>index<font color="#00a0a0">}</font><font color="#a8ff60">&nbsp;</font><font color="#00a0a0">#{</font>separator<font color="#00a0a0">}</font><font color="#a8ff60">&nbsp;</font><font color="#00a0a0">#{</font>value<font color="#00a0a0">}</font><font color="#336633">&quot;</font>
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">applied_list</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@list</font>.map.with_index(&amp;it.apply(<font color="#336633">&quot;</font><font color="#a8ff60">:</font><font color="#336633">&quot;</font>))
&nbsp;&nbsp;<font color="#96cbfe">end</font>

<font color="#96cbfe">end</font></pre>


In case you are wondering, the position you can specify is to tell where the arguments need to go. Position 0 is the method name, so you shouldn't use that, but any other value is okay.  An example might be that you cant to wrap an array of texts into span-tags:

<pre class="ir_black"><font color="#00a0a0">&lt;%=</font>&nbsp;some_texts.map(&amp;it(<font color="#ff73fd">2</font>).content_tag(<font color="#99cc99">:span</font>, <font color="#99cc99">:class</font>&nbsp;=&gt; <font color="#336633">&quot;</font><font color="#a8ff60">foo</font><font color="#336633">&quot;</font>)).to_sentence <font color="#00a0a0">%&gt;</font></pre>

So there you have it. I'm probably solving a problem that doesn't exist. It is however a nice example of the awesome power of Ruby. I hope you've enjoyed this little demonstration of the possible uses of `to_proc`.
