I've updated my Gemfile syntax file, adding a dash of color and making sure it supports all elements of the <a href="http://gembundler.com">Bundler</a> DSL. You can get it <a href="http://github.com/iain/osx_settings/blob/master/.vim/syntax/Gemfile.vim">here</a>. You'll also need to tell vim to automatically use it when opening a Gemfile by adding <a href="http://github.com/iain/osx_settings/blob/master/.vim/ftdetect/Gemfile.vim">this file</a>.

This is how it looks with the <a href="http://github.com/iain/osx_settings/blob/master/.vim/colors/ir_black.vim">ir_black</a> colorscheme:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#96cbfe">source</font>&nbsp;<font color="#99cc99">:rubygems</font>
<font color="#ffd2a7">gem</font>&nbsp;<font color="#336633">'</font><font color="#a8ff60">rails</font><font color="#336633">'</font>
<font color="#ffd2a7">gem</font>&nbsp;<font color="#336633">'</font><font color="#a8ff60">hoptoad_notifier</font><font color="#336633">'</font>
<font color="#ffd2a7">gem</font>&nbsp;<font color="#336633">'</font><font color="#a8ff60">newrelic_rpm</font><font color="#336633">'</font>, <font color="#99cc99">:require</font>&nbsp;=&gt; <font color="#99cc99">false</font>
<font color="#ffd2a7">gem</font>&nbsp;<font color="#336633">'</font><font color="#a8ff60">mysql2</font><font color="#336633">'</font>
<font color="#ffd2a7">gem</font>&nbsp;<font color="#336633">'</font><font color="#a8ff60">devise</font><font color="#336633">'</font>

<font color="#7c7c7c"># ... etc ...</font>

<font color="#96cbfe">platforms</font>&nbsp;<font color="#99cc99">:ruby_18</font>&nbsp;<font color="#6699cc">do</font>
&nbsp;&nbsp;<font color="#ffd2a7">gem</font>&nbsp;<font color="#336633">'</font><font color="#a8ff60">system_timer</font><font color="#336633">'</font>
&nbsp;&nbsp;<font color="#ffd2a7">gem</font>&nbsp;<font color="#336633">'</font><font color="#a8ff60">fastercsv</font><font color="#336633">'</font>
<font color="#6699cc">end</font>

<font color="#96cbfe">group</font>&nbsp;<font color="#99cc99">:development</font>, <font color="#99cc99">:test</font>&nbsp;<font color="#6699cc">do</font>
&nbsp;&nbsp;<font color="#ffd2a7">gem</font>&nbsp;<font color="#336633">'</font><font color="#a8ff60">rspec-rails</font><font color="#336633">'</font>, <font color="#336633">'</font><font color="#a8ff60">2.0.0.beta.20</font><font color="#336633">'</font>
<font color="#6699cc">end</font></pre>

Enjoy!
