Cal it tiny, I don't care. I've made a gem named <a href="http://github.com/iain/basic_named_scopes">BasicNamedScopes</a>.

<h3>Basic Usage</h3>

I was fed up with writing:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#ffffb6">Post</font>.all(<font color="#99cc99">:conditions</font>&nbsp;=&gt; { <font color="#99cc99">:published</font>&nbsp;=&gt; <font color="#99cc99">true</font>&nbsp;}, <font color="#99cc99">:select</font>&nbsp;=&gt; <font color="#99cc99">:title</font>, <font color="#99cc99">:include</font>&nbsp;=&gt; <font color="#99cc99">:author</font>)</pre>

So with BasicNamedScopes, you can now write:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#ffffb6">Post</font>.conditions(<font color="#99cc99">:published</font>&nbsp;=&gt; <font color="#99cc99">true</font>).select(<font color="#99cc99">:title</font>).with(<font color="#99cc99">:author</font>)</pre>

All named scopes are called the same, except for <tt>include</tt>, which is now called <tt>with</tt>, because <tt>include</tt> is a reserved method.

Reuse them by making class methods:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Post</font>&nbsp;&lt; <font color="#ffffb6">ActiveRecord</font>::<font color="#ffffb6">Base</font>
&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#99cc99">self</font>.<font color="#ffd2a7">published</font>
&nbsp;&nbsp;  conditions(<font color="#99cc99">:published</font>&nbsp;=&gt; <font color="#99cc99">true</font>)
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#99cc99">self</font>.<font color="#ffd2a7">visible</font>
&nbsp;&nbsp;&nbsp;&nbsp;conditions(<font color="#99cc99">:visible</font>&nbsp;=&gt; <font color="#99cc99">true</font>)
&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#99cc99">self</font>.<font color="#ffd2a7">index</font>
&nbsp;&nbsp;&nbsp;&nbsp;published.visible
&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font></pre>

Also, the <tt>all</tt>-method is a named scope now, so you can chain after callling <tt>all</tt>, for greater flexibility.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#ffffb6">Post</font>.all.published</pre>

Arrays can be used as multple parameters too, sparing you some brackets.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#ffffb6">Post</font>.with(<font color="#99cc99">:author</font>, <font color="#99cc99">:comments</font>).conditions(<font color="#336633">&quot;</font><font color="#a8ff60">name LIKE ?</font><font color="#336633">&quot;</font>, query)</pre>

The <tt>read_only</tt> and <tt>lock</tt> scopes default to true, but can be adjusted.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#ffffb6">Post</font>.readonly&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <font color="#7c7c7c"># =&gt; same as Post.all(:readonly =&gt; true)</font>
<font color="#ffffb6">Post</font>.readonly(<font color="#99cc99">false</font>)&nbsp;&nbsp;<font color="#7c7c7c"># =&gt; same as Post.all(:readonly =&gt; false)</font></pre>

<h3>Why?</h3>

NamedScopes are really handy and they should play a more central theme in ActiveRecord. While I heard that Rails 3 will support similar syntax, there is no reason to wait any longer.

I find defining named scopes very ugly, especially when dealing with parameters. Just compare the amount of curly braces!

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#7c7c7c"># Using normal named scope:</font>
named_scope <font color="#99cc99">:name_like</font>, <font color="#96cbfe">lambda</font>&nbsp;{ |<font color="#c6c5fe">query</font>|&nbsp;{ <font color="#99cc99">:conditions</font>&nbsp;=&gt; [<font color="#336633">&quot;</font><font color="#a8ff60">name LIKE ?</font><font color="#336633">&quot;</font>, query]&nbsp;} }

<font color="#7c7c7c"># Using BasicNamedScopes</font>
<font color="#96cbfe">def</font>&nbsp;<font color="#99cc99">self</font>.<font color="#ffd2a7">name_like</font>(query)
&nbsp;&nbsp;conditions(<font color="#336633">&quot;</font><font color="#a8ff60">name LIKE ?</font><font color="#336633">&quot;</font>, query)
<font color="#96cbfe">end</font></pre>

Also, regular named scopes don't support using other named scopes at all!

I found myself implementing these named scopes (mostly conditions, but others too) so often, that a little gem like this would be the obvious choice. Use it if a gem like <a href="http://github.com/binarylogic/searchlogic">searchlogic</a> is overkill for your needs.

<h3>Installing</h3>

The gem is called "basic_named_scopes". You know how to install it.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">gem install basic_named_scopes</pre>

Use it in Rails:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black">config.gem <font color="#336633">&quot;</font><font color="#a8ff60">basic_named_scopes</font><font color="#336633">&quot;</font></pre>


<h3>Update</h3>

The syntax is fully compatible with ActiveRecord 3, and if you're using ActiveRecord 3, you don't need to use this gem.
