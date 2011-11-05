We had a programming exercise this week at work. We were set out to write [Conway's Game of
Life](http://en.wikipedia.org/wiki/Conway%27s_Game_of_Life), using pair programming and TDD. It was
a fun and educational evening. I even did some Scala.

Programmers humor dictates me that from time to time I say things like "In Ruby, that's only one
line!" or "In Ruby, that would cost me just one minute!". Putting money where my mouth is, I wrote
the entire application in just one line of Ruby.

So here it is. It looks more like Perl than Ruby. But it works!

``` ruby
String.class_eval{define_method(:to_grid){(self =~ /\A(\d+)x(\d+)\z/ ?
(0...split('x').last.to_i).map{|_| (0...split('x').first.to_i).map{|_| rand > 0.5 } } :
split("\n").map{|row| row.split(//).map{|cell_string| cell_string == "o" } }
).tap{|grid| grid.class.class_eval{define_method(:next){each{|row|
row.each{|cell| cell.class.class_eval{define_method(:next?){|neighbours|
(self && (2..3).include?(neighbours.select{|me| me }.size)) ||
(!self && neighbours.select{|me| me }.size == 3)}}}} &&
enum_for(:each_with_index).map{|row, row_num| row.enum_for(:each_with_index).map{|cell, col_num|
cell.next?([ at(row_num - 1).at(col_num - 1), at(row_num - 1).at(col_num),
at(row_num - 1).at((col_num + 1) % row.size), row.at((col_num + 1) % row.size),
row.at(col_num - 1), at((row_num + 1) % size).at(col_num - 1),
at((row_num + 1) % size).at(col_num), at((row_num + 1) % size).at((col_num + 1) % row.size) ])
} }} && define_method(:to_s){map{|row| row.map{|cell| cell ? "o" : "." }.join }.join("\n")}}}}}
```

I didn't cheat! No semicolons where harmed during the making of the spaghetti code. I did enter some
newlines in the code shown above to prevent wild scrollbars from appearing.

You can use it like this:

``` ruby
# generate a random grid
grid = "100x30".to_grid
# show the grid:
puts grid.to_s
# get the next generation of the grid
new_grid = grid.next
# convert a drawn out grid to a grid
new_grid.to_s.to_grid == new_grid # returns true
```

If you want to know how it works, or make an animation of it, [it's all
here](http://gist.github.com/384487).

This is what it looks like:

<figure class="ir_black"><img src="/game-of-life.png" alt="Conway&#039;s Game of Life" title="Conway&#039;s Game of Life" width="754" height="497"></figure>

It was a fun exercise, but I don't think I'll be writing all my code like this in the future :)
