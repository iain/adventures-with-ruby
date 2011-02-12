After using <a href="http://haml.hamptoncatlin.com/" title="Haml Homepage" target="_blank">Haml</a> for <a href="/first-haml-evaluation/" title="First Haml evaluation">over a month</a> now, I can now really evaluate how Haml is to work with from day to day basis.

Haml actually is a blessing.  Doing minor adjustments is very easy, your code remains looking nice, the output keeps looking nice. Just be sure to know how to shift blocks of code to the left or right in your favorite editor.<!--more-->

OK, there are some downsides. You have very little control over how you HTML turns out. It is usually spot on, but sometimes you do have to use ERB. Making your own autocomplete boxes for instance. Here I needed to use ERB, because the indentation would end up in the textfield, which would break the functionality in IE6. You still have to use ERB in emails too, since you cannot afford to go to a new line with every variable.

One thing that especially  enjoys me is that you cannot go to the next line unpunished. Sometimes you're tempted to enter a long line of Ruby code within your template. In ERB you could just go to the next line and continue there. With Haml that's not the case. So rather than making long and ugly lines of code, you should be triggered to use helpers more often. I need that nudge in the back.

But those are just tiny problems. After a while of using Haml, I can't imagine going back to ERB for an entire website. It is too tiresome using ERB, compared to Haml. And a good programmer is a lazy programmer, although admittedly not the other way round. ;)

One more tip: use helpers to render partials or partial-layouts to output HTML. That way you can have this kind of code:
<pre lang="rails">
# in your view:
= in_special_block do
  %li.username=  h(@user.name)
  %li.edit_link= link_to( 'edit', edit_user_url(@user) )

# in your helper:
def in_special_block
  # do stuff
  render(:layout => 'shared/block_layout') { yield }
  # other stuff
end</pre>
