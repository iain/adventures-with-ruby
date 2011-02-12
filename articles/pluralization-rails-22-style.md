[Railscast episode 132](http://railscasts.com/episodes/132-helpers-outside-views) talks about using helpers outside views. All in all a good and useful screencast. I only have one comment: In Rails 2.2 internationalized pluralization goes like this:
<pre class="ir_black"><font color="#ffffb6">I18n</font>.t(<font color="#99cc99">:people</font>, <font color="#99cc99">:count</font>&nbsp;=&gt; <font color="#c6c5fe">@people</font>.size)</pre>

With these translation-files:

<pre class="ir_black"><font color="#c6c5fe">en</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;<font color="#c6c5fe">people</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">one</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;one person&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">other</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;%{count} people&quot;</font></pre>

<pre class="ir_black"><font color="#c6c5fe">nl</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;<font color="#c6c5fe">people</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">one</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;een persoon&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">other</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;%{count} personen&quot;</font>
</pre>
