Rails 3 is coming. All the big changes are spoken of elsewhere, so I'm going to mention some small changes. Here are 3 random new methods added to ActiveSupport:

### presence

First up is `Object#presence` which is a shortcut for `Object#present? && Object`. It is a bit of a sanitizer. Empty strings and other blank values will return `nil` and any other value will return itself. Use this one and your code might be a tad cleaner.

<pre class="ir_black"><font color="#336633">&quot;&quot;</font>.presence <font color="#7c7c7c"># =&gt; nil</font>
<font color="#336633">&quot;</font><font color="#a8ff60">foo</font><font color="#336633">&quot;</font>.presence <font color="#7c7c7c">#=&gt; &quot;foo&quot;</font>

<font color="#7c7c7c"># without presence:</font>
<font color="#6699cc">if</font>&nbsp;params[<font color="#99cc99">:foo</font>].present? &amp;&amp; (foo = params[<font color="#99cc99">:foo</font>])
&nbsp;&nbsp;<font color="#7c7c7c"># ..</font>
<font color="#6699cc">end</font>

<font color="#7c7c7c"># with presence:</font>
<font color="#6699cc">if</font>&nbsp;foo = params[<font color="#99cc99">:foo</font>].presence
&nbsp;&nbsp;<font color="#7c7c7c"># ...</font>
<font color="#6699cc">end</font>

<font color="#7c7c7c"># The example Rails gives:</font>
state&nbsp;&nbsp; = params[<font color="#99cc99">:state</font>]&nbsp;&nbsp; <font color="#6699cc">if</font>&nbsp;params[<font color="#99cc99">:state</font>].present?
country = params[<font color="#99cc99">:country</font>] <font color="#6699cc">if</font>&nbsp;params[<font color="#99cc99">:country</font>].present?
region&nbsp;&nbsp;= state || country || <font color="#336633">'</font><font color="#a8ff60">US</font><font color="#336633">'</font>
<font color="#7c7c7c"># ...becomes:</font>
region = params[<font color="#99cc99">:state</font>].presence || params[<font color="#99cc99">:country</font>].presence || <font color="#336633">'</font><font color="#a8ff60">US</font><font color="#336633">'</font></pre>

I like this way of cleaning up you're code. I guess it's Rubyesque to feel the need to tidy and shorten your code like this.

### uniq_by

Another funny one is `Array.uniq_by` (and it sister-with-a-bang-method). It works as select, but returns only the first element from the array that complies with the block you gave it. Here are some examples to illustrate that:

<pre class="ir_black">[&nbsp;<font color="#ff73fd">1</font>, <font color="#ff73fd">2</font>, <font color="#ff73fd">3</font>, <font color="#ff73fd">4</font>&nbsp;].uniq_by(&amp;<font color="#99cc99">:odd?</font>) <font color="#7c7c7c"># =&gt; [ 1, 2 ]</font>

posts = <font color="#336633">%W&quot;</font><font color="#a8ff60">foo bar foo</font><font color="#336633">&quot;</font>.map.with_index <font color="#6699cc">do</font>&nbsp;|<font color="#c6c5fe">title</font>, <font color="#c6c5fe">i</font>|
&nbsp;&nbsp;<font color="#ffffb6">Post</font>.create(<font color="#99cc99">:title</font>&nbsp;=&gt; title, <font color="#99cc99">:index</font>&nbsp;=&gt; i)
<font color="#6699cc">end</font>
posts.uniq_by(&amp;<font color="#99cc99">:title</font>)
<font color="#7c7c7c"># =&gt; [ Post(&quot;foo&quot;, 0), Post(&quot;bar&quot;, 1) ] ( and not Post(&quot;foo&quot;, 2) )</font>

some_array.uniq_by(&amp;<font color="#99cc99">:object_id</font>) <font color="#7c7c7c"># same as some_array.uniq</font></pre>

### exclude?

And the final one for today is `exclude?` which is the opposite of `include?`. Nobody likes the exclamation mark before predicate methods.

<pre class="ir_black"><font color="#7c7c7c"># yuck:</font>
!some_array.include?(some_value)
<font color="#7c7c7c"># better:</font>
some_array.exclude?(some_value)</pre>

And it also works on strings:

<pre class="ir_black"><font color="#7c7c7c"># even more yuck:</font>
!<font color="#336633">&quot;</font><font color="#a8ff60">The quick fox</font><font color="#336633">&quot;</font>.include?(<font color="#336633">&quot;</font><font color="#a8ff60">quick</font><font color="#336633">&quot;</font>) <font color="#7c7c7c"># =&gt; false</font>
<font color="#7c7c7c"># better:</font>
<font color="#336633">&quot;</font><font color="#a8ff60">The quick fox</font><font color="#336633">&quot;</font>.exclude?(<font color="#336633">&quot;</font><font color="#a8ff60">quick</font><font color="#336633">&quot;</font>) <font color="#7c7c7c"># =&gt; false</font></pre>

The full release notes of Rails 3 can be [read here](http://guides.rails.info/3_0_release_notes.html).
