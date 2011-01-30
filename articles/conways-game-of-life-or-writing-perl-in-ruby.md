We had a programming exercise this week at work. We were set out to write <a href="http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life">Conway's Game of Life</a>, using pair programming and TDD. It was a fun and educational evening. I even did some Scala.

Programmers humor dictates me that from time to time I say things like "In Ruby, that's only one line!" or "In Ruby, that would cost me just one minute!". Putting money where my mouth is, I wrote the entire application in just one line of Ruby.

So here it is. It looks more like Perl than Ruby. But it works!

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#ffffb6">String</font>.class_eval{define_method(<font color="#99cc99">:to_grid</font>){(<font color="#99cc99">self</font>&nbsp;=~ <font color="#ff8000">/</font><font color="#e18964">\A</font><font color="#e18964">(</font><font color="#e18964">\d</font><font color="#e18964">+</font><font color="#e18964">)</font><font color="#b18a3d">x</font><font color="#e18964">(</font><font color="#e18964">\d</font><font color="#e18964">+</font><font color="#e18964">)</font><font color="#e18964">\z</font><font color="#ff8000">/</font>&nbsp;?
(<font color="#ff73fd">0</font>...split(<font color="#336633">'</font><font color="#a8ff60">x</font><font color="#336633">'</font>).last.to_i).map{|<font color="#c6c5fe">_</font>|&nbsp;(<font color="#ff73fd">0</font>...split(<font color="#336633">'</font><font color="#a8ff60">x</font><font color="#336633">'</font>).first.to_i).map{|<font color="#c6c5fe">_</font>|&nbsp;rand &gt; <font color="#ff73fd">0.5</font>&nbsp;} } :
split(<font color="#336633">&quot;</font><font color="#e18964">\n</font><font color="#336633">&quot;</font>).map{|<font color="#c6c5fe">row</font>|&nbsp;row.split(<font color="#ff8000">//</font>).map{|<font color="#c6c5fe">cell_string</font>|&nbsp;cell_string == <font color="#336633">&quot;</font><font color="#a8ff60">o</font><font color="#336633">&quot;</font>&nbsp;} }
).tap{|<font color="#c6c5fe">grid</font>|&nbsp;grid.class.class_eval{define_method(<font color="#99cc99">:next</font>){each{|<font color="#c6c5fe">row</font>|&nbsp;
row.each{|<font color="#c6c5fe">cell</font>|&nbsp;cell.class.class_eval{define_method(<font color="#99cc99">:next?</font>){|<font color="#c6c5fe">neighbours</font>|&nbsp;
(<font color="#99cc99">self</font>&nbsp;&amp;&amp; (<font color="#ff73fd">2</font>..<font color="#ff73fd">3</font>).include?(neighbours.select{|<font color="#c6c5fe">me</font>|&nbsp;me }.size)) ||
(!<font color="#99cc99">self</font>&nbsp;&amp;&amp; neighbours.select{|<font color="#c6c5fe">me</font>|&nbsp;me }.size == <font color="#ff73fd">3</font>)}}}} &amp;&amp;
enum_for(<font color="#99cc99">:each_with_index</font>).map{|<font color="#c6c5fe">row</font>, <font color="#c6c5fe">row_num</font>|&nbsp;row.enum_for(<font color="#99cc99">:each_with_index</font>).map{|<font color="#c6c5fe">cell</font>, <font color="#c6c5fe">col_num</font>|&nbsp;
cell.next?([&nbsp;at(row_num - <font color="#ff73fd">1</font>).at(col_num - <font color="#ff73fd">1</font>), at(row_num - <font color="#ff73fd">1</font>).at(col_num),
at(row_num - <font color="#ff73fd">1</font>).at((col_num + <font color="#ff73fd">1</font>) % row.size), row.at((col_num + <font color="#ff73fd">1</font>) % row.size),
row.at(col_num - <font color="#ff73fd">1</font>), at((row_num + <font color="#ff73fd">1</font>) % size).at(col_num - <font color="#ff73fd">1</font>),
at((row_num + <font color="#ff73fd">1</font>) % size).at(col_num), at((row_num + <font color="#ff73fd">1</font>) % size).at((col_num + <font color="#ff73fd">1</font>) % row.size) ])
} }} &amp;&amp; define_method(<font color="#99cc99">:to_s</font>){map{|<font color="#c6c5fe">row</font>|&nbsp;row.map{|<font color="#c6c5fe">cell</font>|&nbsp;cell ? <font color="#336633">&quot;</font><font color="#a8ff60">o</font><font color="#336633">&quot;</font>&nbsp;: <font color="#336633">&quot;</font><font color="#a8ff60">.</font><font color="#336633">&quot;</font>&nbsp;}.join }.join(<font color="#336633">&quot;</font><font color="#e18964">\n</font><font color="#336633">&quot;</font>)}}}}}
</pre>

I didn't cheat! No semicolons where harmed during the making of the spaghetti code. I did enter some newlines in the code shown above to prevent wild scrollbars from appearing.

You can use it like this:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#7c7c7c"># generate a random grid</font>
grid = <font color="#336633">&quot;</font><font color="#a8ff60">100x30</font><font color="#336633">&quot;</font>.to_grid
<font color="#7c7c7c"># show the grid:</font>
puts grid.to_s
<font color="#7c7c7c"># get the next generation of the grid</font>
new_grid = grid.next
<font color="#7c7c7c"># convert a drawn out grid to a grid</font>
new_grid.to_s.to_grid == new_grid <font color="#7c7c7c"># returns true</font>
</pre>

If you want to know how it works, or make an animation of it, <a href="http://gist.github.com/384487">it's all here</a>.

This is what it looks like:

<img src="http://iain.nl/wp-content/uploads/2010/04/Screen-shot-2010-04-30-at-16.42.51.png" alt="Conway&#039;s Game of Life" title="Conway&#039;s Game of Life" width="754" height="497" class="alignnone size-full wp-image-698 ir_black" />

It was a fun exercise, but I don't think I'll be writing all my code like this in the future :)
