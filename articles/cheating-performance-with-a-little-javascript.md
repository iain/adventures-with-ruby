This little trick works with most websites with a menubar. When you have a menu that changes color pending on which page you are, you can cheat a bit on the perceived performance of loading pages. And all with just a little bit of Javascript. Intercept the links to change the state to active, before actually loading the page. The menu will feel much more responsive!

Imagine you add a class to the menu item that is active, like this:

<pre style="background: #000000; color: #f6f3e8" class="ir_black"><font face="Monaco, monospace"><font color="#96cbfe">&lt;</font>nav<font color="#96cbfe">&nbsp;</font><font color="#ffffb6">id</font><font color="#96cbfe">=</font><font color="#a8ff60">&quot;menu&quot;</font><font color="#96cbfe">&gt;</font>
&nbsp;&nbsp;<font color="#96cbfe">&lt;</font><font color="#6699cc">ul</font><font color="#96cbfe">&gt;</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">&lt;</font><font color="#6699cc">li</font><font color="#96cbfe">&gt;&lt;</font><font color="#6699cc">a</font><font color="#96cbfe">&nbsp;</font><font color="#ffffb6">href</font><font color="#96cbfe">=</font><font color="#a8ff60">&quot;foo.html&quot;</font><font color="#96cbfe">&gt;</font><font color="#80a0ff"><u>Foo</u></font><font color="#c6c5fe">&lt;/</font><font color="#6699cc">a</font><font color="#c6c5fe">&gt;&lt;/</font><font color="#6699cc">li</font><font color="#c6c5fe">&gt;</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">&lt;</font><font color="#6699cc">li</font><font color="#96cbfe">&nbsp;</font><font color="#ffffb6">class</font><font color="#96cbfe">=</font><font color="#a8ff60">&quot;active&quot;</font><font color="#96cbfe">&gt;&lt;</font><font color="#6699cc">a</font><font color="#96cbfe">&nbsp;</font><font color="#ffffb6">href</font><font color="#96cbfe">=</font><font color="#a8ff60">&quot;bar.html&quot;</font><font color="#96cbfe">&gt;</font><font color="#80a0ff"><u>Bar</u></font><font color="#c6c5fe">&lt;/</font><font color="#6699cc">a</font><font color="#c6c5fe">&gt;&lt;/</font><font color="#6699cc">li</font><font color="#c6c5fe">&gt;</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">&lt;</font><font color="#6699cc">li</font><font color="#96cbfe">&gt;&lt;</font><font color="#6699cc">a</font><font color="#96cbfe">&nbsp;</font><font color="#ffffb6">href</font><font color="#96cbfe">=</font><font color="#a8ff60">&quot;baz.html&quot;</font><font color="#96cbfe">&gt;</font><font color="#80a0ff"><u>Baz</u></font><font color="#c6c5fe">&lt;/</font><font color="#6699cc">a</font><font color="#c6c5fe">&gt;&lt;/</font><font color="#6699cc">li</font><font color="#c6c5fe">&gt;</font>
&nbsp;&nbsp;<font color="#c6c5fe">&lt;/</font><font color="#6699cc">ul</font><font color="#c6c5fe">&gt;</font>
<font color="#c6c5fe">&lt;/</font>nav<font color="#c6c5fe">&gt;</font>
</font></pre>

Then all you would need to do is something like this with jQuery:

<pre style="background: #000000; color: #f6f3e8" class="ir_black"><font face="Monaco, monospace">$(<font color="#ffd2a7">function</font>()&nbsp;<font color="#ffd2a7">{</font>
&nbsp;&nbsp;$(<font color="#a8ff60">'nav#menu a'</font>).click(<font color="#ffd2a7">function</font>()<font color="#ffd2a7">{</font>
&nbsp;&nbsp;&nbsp;&nbsp;$(<font color="#a8ff60">'nav#menu li'</font>).removeClass(<font color="#a8ff60">'active'</font>);
&nbsp;&nbsp;&nbsp;&nbsp;$(<font color="#c6c5fe">this</font>).blur().parents(<font color="#a8ff60">'li'</font>).addClass(<font color="#a8ff60">'active'</font>);
&nbsp;&nbsp;<font color="#ffd2a7">}</font>);
<font color="#ffd2a7">}</font>);</font></pre>

I've added a `blur()`-command in between, so the dotted lines disappear earlier.

Try it out, you can really notice the difference. It works best when the menu items don't move, but only change appearance.

<h3>Update</h3>

Because I switched to Disqus, some nice comments have gone. [Stefan Borsje](http://twitter.com/sborsje), of [Pressdoc](http://pressdoc.com) fame, replied with this concern:

> To be honest, I don’t like it very much. It really changes a basic way the web works; you click on something, the page loads (and optionally shows an activity indicator) and you get to see the result. With this method you already get see part of the result even before the actual loading fase, which could easily confuse users by letting them think the page is already done but nothing has changed.


I agree that you should be careful applying this technique. But the clicking of the link is done instantly, so the user would see the page loading immediately, thus he/she wouldn't think the page is done. This technique works best if your pages are speedy enough, but can use just a bit more oomph.
