Want to build a quick website or backend? Want to make it look good, but without adding too much effort in it? Then this recipe is for you!

The <a href="http://jqueryui.com">jQuery UI framework</a> contains some nice styles and some nice javascript to accompany it. But the class names you're ought to be using are awkward. Nobody wants to add "ui-widget-header" to their classes. We have standards; we want semantical html and css, even if we don't want to be doing much styling ourselves.

Editing the css file that jQuery UI gives you is not an option; that would be a hideous mess even before we get started. Luckily, <a href="http://sass-lang.com">Sass</a> can help us. Sass introduced the "<tt>@extend</tt>" method since version 3, which we can (ab)use.

We need to convert the css file jQuery gave us to Sass. I'm a big fan of sass, not scss, so I'll be using that:

<pre style="background: #000000; color: #f6f3e8" class="ir_black"><font face="Monaco, monospace">sass-convert --from css --to sass \
&nbsp;&nbsp;path/to/jquery-ui-1.8.2.custom.css &gt; app/stylesheets/_jquery_ui.sass
</font></pre>


I've included an underscore so it won't be compiled to a real css file when I run my application. I've also configured Sass to load my sass files from <tt>app/stylesheets</tt>.

Next, create your own sass/scss file and use <tt>@extend</tt>:

<table>
<tr>
<th>screen.sass</th>
<th>screen.scss</th>
</tr>
<tr>
<td style="vertical-align: top;">
<pre style="background: #000000; color: #f6f3e8" class="ir_black"><font face="Monaco, monospace"><font color="#96cbfe">@import jquery_ui</font>

<font color="#e18964">.</font><font color="#ffffb6">project-header</font>
&nbsp;&nbsp;@extend <font color="#e18964">.</font><font color="#ffffb6">ui-widget</font>
&nbsp;&nbsp;@extend <font color="#e18964">.</font><font color="#ffffb6">ui-widget-header</font>
&nbsp;&nbsp;@extend <font color="#e18964">.</font><font color="#ffffb6">ui-corner-all</font>
</font></pre>
</td>

<td>
<pre style="background: #000000; color: #f6f3e8" class="ir_black"><font face="Monaco, monospace"><font color="#96cbfe">@import &quot;jquery_ui&quot;;</font>

<font color="#e18964">.</font><font color="#ffffb6">project-header</font>&nbsp;<font color="#ffd2a7">{</font>
&nbsp;&nbsp;<font color="#96cbfe">@extend</font>&nbsp;<font color="#e18964">.</font><font color="#ffffb6">ui-widget</font>;
&nbsp;&nbsp;<font color="#96cbfe">@extend</font>&nbsp;<font color="#e18964">.</font><font color="#ffffb6">ui-widget-header</font>;
&nbsp;&nbsp;<font color="#96cbfe">@extend</font>&nbsp;<font color="#e18964">.</font><font color="#ffffb6">ui-corner-all</font>;
<font color="#ffd2a7">}</font>
</font></pre>

</td>
</tr>
</table>

Now you just need to add the class "<tt>project-header</tt>" to the appropriate HTML element, include the compiled "screen.css" tag in your layout and you're done!

Be sure to use the javascript too, for nice interactions. The javascript will add classes dynamically to certain elements. They will still work.

So what really happens? Well, <tt>@extend</tt> appends your own selector to the jQuery selector you specified. So the compiled jQuery css would've looked like this before:

<pre style="background: #000000; color: #f6f3e8" class="ir_black"><font face="Monaco, monospace"><font color="#ffd2a7">.ui-widget-header</font>&nbsp;<font color="#ffd2a7">{</font>
&nbsp;&nbsp;<font color="#ffffb6">border</font>: <font color="#ff73fd">1px</font>&nbsp;<font color="#ffffb6">solid</font>&nbsp;<font color="#99cc99">#aaaaaa</font>;
&nbsp;&nbsp;<font color="#7c7c7c">/* more... */</font>
<font color="#ffd2a7">}</font></font></pre>

But after doing our <tt>@extend</tt>-trick, it will now compile to:

<pre style="background: #000000; color: #f6f3e8" class="ir_black"><font face="Monaco, monospace"><font color="#ffd2a7">.ui-widget-header</font><span style="background-color: #000000"><font color="#f6f3e8">,</font></span>&nbsp;<font color="#ffd2a7">.project-title</font>&nbsp;<font color="#ffd2a7">{</font>
&nbsp;&nbsp;<font color="#ffffb6">border</font>: <font color="#ff73fd">1px</font>&nbsp;<font color="#ffffb6">solid</font>&nbsp;<font color="#99cc99">#aaaaaa</font>;
&nbsp;&nbsp;<font color="#7c7c7c">/* more... */</font>
<font color="#ffd2a7">}</font></font></pre>


Sass parsing is incredibly smart. Really smart. The original jQuery css will be changed automatically. Awesome! And without hardly any effort from my side!

For more awesomeness in styling: Have a look at <a href="http://compass-style.org">compass</a>. It will be worth your time!

