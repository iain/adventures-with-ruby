So, about one month ago, I [promised](/monkey-patch-of-the-month-group_by/) to share some useful monkey patches every month. Here is the second one. Your own monkey patches are still more than welcome!

I often find myself writing code like this:

<pre class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Foo</font>
&nbsp;&nbsp;<font color="#6699cc">attr_reader</font>&nbsp;<font color="#99cc99">:bar</font>, <font color="#99cc99">:baz</font>
&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">initialize</font>(bar, baz)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@bar</font>, <font color="#c6c5fe">@baz</font>&nbsp;= bar, baz
&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font></pre>

This can be very annoying to maintain. The variable names are repeated four times, within three lines of code!

Ideally, I'd want to write something like this:

<pre class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Foo</font>
&nbsp;&nbsp;attr_initializer <font color="#99cc99">:bar</font>, <font color="#99cc99">:baz</font>
<font color="#96cbfe">end</font></pre>

Much better, if you ask me. Here is one example of how to do this.

<pre class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Class</font>
&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">attr_initializer</font>(*attributes)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">attr_reader</font>&nbsp;*attributes
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">class_eval</font>&nbsp;&lt;&lt;-<font color="#336633">RUBY</font>
<font color="#a8ff60">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;def initialize(</font><font color="#00a0a0">#{</font>attributes.join(<font color="#336633">'</font><font color="#a8ff60">, </font><font color="#336633">'</font>)<font color="#00a0a0">}</font><font color="#a8ff60">)</font>
<font color="#a8ff60">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font><font color="#00a0a0">#{</font>attributes.map{ |<font color="#c6c5fe">attribute</font>|&nbsp;<font color="#336633">&quot;</font><font color="#a8ff60">@</font><font color="#00a0a0">#{</font>attribute<font color="#00a0a0">}</font><font color="#336633">&quot;</font>&nbsp;}.join(<font color="#336633">'</font><font color="#a8ff60">, </font><font color="#336633">'</font>)<font color="#00a0a0">}</font><font color="#a8ff60">&nbsp;= </font><font color="#00a0a0">#{</font>attributes.join(<font color="#336633">'</font><font color="#a8ff60">, </font><font color="#336633">'</font>)<font color="#00a0a0">}</font>
<font color="#a8ff60">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;end</font>
<font color="#a8ff60">&nbsp;&nbsp;&nbsp;&nbsp;</font><font color="#336633">RUBY</font>
&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font></pre>

No piece of code is complete without tests, so this is it:

<pre class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">AttrInitializerTests</font>&nbsp;&lt; <font color="#ffffb6">Test</font>::<font color="#ffffb6">Unit</font>::<font color="#ffffb6">TestCase</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">test_attr_initializer</font>
&nbsp;&nbsp;&nbsp;&nbsp;klass = <font color="#ffffb6">Class</font>.new <font color="#6699cc">do</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;attr_initializer <font color="#99cc99">:foo</font>, <font color="#99cc99">:bar</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">end</font>
&nbsp;&nbsp;&nbsp;&nbsp;object = klass.new(<font color="#ff73fd">1</font>, <font color="#336633">'</font><font color="#a8ff60">b</font><font color="#336633">'</font>)
&nbsp;&nbsp;&nbsp;&nbsp;assert_equal <font color="#ff73fd">1</font>, object.foo
&nbsp;&nbsp;&nbsp;&nbsp;assert_equal <font color="#336633">'</font><font color="#a8ff60">b</font><font color="#336633">'</font>, object.bar
&nbsp;&nbsp;<font color="#96cbfe">end</font>
&nbsp;
<font color="#96cbfe">end</font></pre>
