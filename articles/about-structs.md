Recently I talked about a [monkey patch called attr_initializer](/monkey-patch-of-the-month-attr_initializer), allowing you to write code like this:

<pre class="ir_black"><font face="Monaco, monospace"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">FooBar</font>
&nbsp;&nbsp;attr_initializer <font color="#99cc99">:foo</font>, <font color="#99cc99">:bar</font>
&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">to_s</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#336633">&quot;</font><font color="#a8ff60">your </font><font color="#00a0a0">#{</font>foo<font color="#00a0a0">}</font><font color="#a8ff60">&nbsp;is </font><font color="#00a0a0">#{</font>bar<font color="#00a0a0">}</font><font color="#336633">&quot;</font>
&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font>

<font color="#ffffb6">FooBar</font>.new(<font color="#336633">'</font><font color="#a8ff60">foo</font><font color="#336633">'</font>, <font color="#336633">'</font><font color="#a8ff60">bar</font><font color="#336633">'</font>)</font></pre>


But there is a way of doing it without a monkey patch. Use the [Struct](http://apidock.com/ruby/Struct).

<pre class="ir_black"><font face="Monaco, monospace"><font color="#ffffb6">FooBar</font>&nbsp;= <font color="#ffffb6">Struct</font>.new(<font color="#99cc99">:foo</font>, <font color="#99cc99">:bar</font>) <font color="#6699cc">do</font>
&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">to_s</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#336633">&quot;</font><font color="#a8ff60">your </font><font color="#00a0a0">#{</font>foo<font color="#00a0a0">}</font><font color="#a8ff60">&nbsp;is </font><font color="#00a0a0">#{</font>bar<font color="#00a0a0">}</font><font color="#336633">&quot;</font>
&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#6699cc">end</font>

<font color="#ffffb6">FooBar</font>.new(<font color="#336633">'</font><font color="#a8ff60">foo</font><font color="#336633">'</font>, <font color="#336633">'</font><font color="#a8ff60">bar</font><font color="#336633">'</font>)
</font></pre>

Pretty cool.

<h3>Update</h3>

As was pointed out in my comments by [Radoslav Stankov](http://rstankov.com/) (which you can't see anymore, because I switched to Disqus), you can also do this:

<pre class="ir_black"><font face="Monaco, monospace"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">FooBar</font>&nbsp;&lt; <font color="#ffffb6">Struct</font>.new(<font color="#99cc99">:foo</font>, <font color="#99cc99">:bar</font>)
&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">to_s</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#336633">&quot;</font><font color="#a8ff60">your </font><font color="#00a0a0">#{</font>foo<font color="#00a0a0">}</font><font color="#a8ff60">&nbsp;is </font><font color="#00a0a0">#{</font>bar<font color="#00a0a0">}</font><font color="#336633">&quot;</font>
&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font>

<font color="#ffffb6">FooBar</font>.new(<font color="#336633">'</font><font color="#a8ff60">foo</font><font color="#336633">'</font>, <font color="#336633">'</font><font color="#a8ff60">bar</font><font color="#336633">'</font>)
</font></pre>

I use this one more often, actually.

One final note: the parameters here aren't stored as instance variables, they can only be accessed through their accessor methods.
