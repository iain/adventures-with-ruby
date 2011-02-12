Here is the next installment of a series of guides I'm writing for internationalizing a Rails 2.2 application. Please read the first part, [Translating ActiveRecord](/translating-activerecord/), if you haven't already. This time I'm going to talk about how to localize dates and times to a specific language.

First a small recap in how to load locales. Add this to a new initializer:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#ffffb6">I18n</font>.load_path += <font color="#ffffb6">Dir</font>.glob(<font color="#336633">&quot;</font><font color="#00a0a0">#{</font><font color="#ffffb6">RAILS_ROOT</font><font color="#00a0a0">}</font><font color="#a8ff60">/app/locales/**/*.yml</font><font color="#336633">&quot;</font>)</pre>

This has been changed at a very late moment. `I18n.store_translations` and `I18n.load_translations` have been removed.

After that, you need to create a place to store your locales. Make the directory `app/locales/nl-NL/` and place your yaml files in there. Here is the English version of the locale-file:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#c6c5fe">en-US</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;<font color="#c6c5fe">date</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">formats</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp; <font color="#7c7c7c">&nbsp;# Use the strftime parameters for formats.</font>
&nbsp;&nbsp;&nbsp;&nbsp; <font color="#7c7c7c">&nbsp;# When no format has been given, it uses default.</font>
&nbsp;&nbsp;&nbsp;&nbsp; <font color="#7c7c7c">&nbsp;# You can provide other formats here if you like!</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">default</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;%Y-%m-%d&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">short</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;%b %d&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">long</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;%B %d, %Y&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">day_names</font><font color="#00a0a0">:</font>&nbsp;<font color="#ffffff">[</font>Sunday<font color="#00a0a0">,</font>&nbsp;Monday<font color="#00a0a0">,</font>&nbsp;Tuesday<font color="#00a0a0">,</font>&nbsp;Wednesday<font color="#00a0a0">,</font>&nbsp;Thursday<font color="#00a0a0">,</font>&nbsp;Friday<font color="#00a0a0">,</font>&nbsp;Saturday<font color="#ffffff">]</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">abbr_day_names</font><font color="#00a0a0">:</font>&nbsp;<font color="#ffffff">[</font>Sun<font color="#00a0a0">,</font>&nbsp;Mon<font color="#00a0a0">,</font>&nbsp;Tue<font color="#00a0a0">,</font>&nbsp;Wed<font color="#00a0a0">,</font>&nbsp;Thu<font color="#00a0a0">,</font>&nbsp;Fri<font color="#00a0a0">,</font>&nbsp;Sat<font color="#ffffff">]</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
&nbsp;&nbsp; <font color="#7c7c7c">&nbsp;# Don't forget the nil at the beginning; there's no such thing as a 0th month</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">month_names</font><font color="#00a0a0">:</font>&nbsp;<font color="#ffffff">[</font>~<font color="#00a0a0">,</font>&nbsp;January<font color="#00a0a0">,</font>&nbsp;February<font color="#00a0a0">,</font>&nbsp;March<font color="#00a0a0">,</font>&nbsp;April<font color="#00a0a0">,</font>&nbsp;May<font color="#00a0a0">,</font>&nbsp;June<font color="#00a0a0">,</font>&nbsp;July<font color="#00a0a0">,</font>&nbsp;August<font color="#00a0a0">,</font>&nbsp;September<font color="#00a0a0">,</font>&nbsp;October<font color="#00a0a0">,</font>&nbsp;November<font color="#00a0a0">,</font>&nbsp;December<font color="#ffffff">]</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">abbr_month_names</font><font color="#00a0a0">:</font>&nbsp;<font color="#ffffff">[</font>~<font color="#00a0a0">,</font>&nbsp;Jan<font color="#00a0a0">,</font>&nbsp;Feb<font color="#00a0a0">,</font>&nbsp;Mar<font color="#00a0a0">,</font>&nbsp;Apr<font color="#00a0a0">,</font>&nbsp;May<font color="#00a0a0">,</font>&nbsp;Jun<font color="#00a0a0">,</font>&nbsp;Jul<font color="#00a0a0">,</font>&nbsp;Aug<font color="#00a0a0">,</font>&nbsp;Sep<font color="#00a0a0">,</font>&nbsp;Oct<font color="#00a0a0">,</font>&nbsp;Nov<font color="#00a0a0">,</font>&nbsp;Dec<font color="#ffffff">]</font>
&nbsp;&nbsp; <font color="#7c7c7c">&nbsp;# Used in date_select and datime_select.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">order</font><font color="#00a0a0">:</font>&nbsp;<font color="#ffffff">[</font>&nbsp;<font color="#00a0a0">:</font>year<font color="#00a0a0">,</font>&nbsp;<font color="#00a0a0">:</font>month<font color="#00a0a0">,</font>&nbsp;<font color="#00a0a0">:</font>day <font color="#ffffff">]</font>

&nbsp;&nbsp;<font color="#c6c5fe">time</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">formats</font><font color="#00a0a0">:</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">default</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;%a, %d %b %Y %H:%M:%S %z&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">short</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;%d %b %H:%M&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">long</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;%B %d, %Y %H:%M&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">am</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;am&quot;</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">pm</font><font color="#00a0a0">:</font>&nbsp;<font color="#a8ff60">&quot;pm&quot;</font></pre>

All you need to do is replace the English terms with the translated versions. Remember that all these keys are necessary to have. If you leave out, say month_names, it won't work at all.

After this is done, translate dates and times like this:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#ffffb6">I18n</font>.localize(<font color="#ffffb6">Date</font>.today)</pre>

If you want to use any of the other formats, specify this in the options hash:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#ffffb6">I18n</font>.localize(<font color="#ffffb6">Date</font>.today, <font color="#99cc99">:format</font>&nbsp;=&gt; <font color="#99cc99">:short</font>)</pre>

One more tip: you can add as many formats as you like, but remember that formats like `:db` are reserved for obvious reasons. Here is an overview of the [strftime syntax in Ruby](http://www.ruby-doc.org/core/classes/Time.html#M000297).

**PS.** Rails 2.2 RC1 is really really close now!
