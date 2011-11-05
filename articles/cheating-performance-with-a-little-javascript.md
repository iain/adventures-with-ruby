This little trick works with most websites with a menubar. When you have a menu that changes color
pending on which page you are, you can cheat a bit on the perceived performance of loading pages.
And all with just a little bit of Javascript. Intercept the links to change the state to active,
before actually loading the page. The menu will feel much more responsive!

Imagine you add a class to the menu item that is active, like this:

``` html
<nav id="menu">
  <ul>
    <li><a href="foo.html">Foo</a></li>
    <li class="active"><a href="bar.html">Bar</a></li>
    <li><a href="baz.html">Baz</a></li>
  </ul>
</nav>
```

Then all you would need to do is something like this with jQuery:

``` javascript
$(function() {
  $('nav#menu a').click(function(){
    $('nav#menu li').removeClass('active');
    $(this).blur().parents('li').addClass('active');
  });
});
```

I've added a `blur()`-command in between, so the dotted lines disappear earlier.

Try it out, you can really notice the difference. It works best when the menu items don't move, but
only change appearance.

### Update

Because I switched to Disqus, some nice comments have gone. [Stefan
Borsje](http://twitter.com/sborsje), of [Pressdoc](http://pressdoc.com) fame, replied with this
concern:

> To be honest, I don’t like it very much. It really changes a basic way the web works; you click
on something, the page loads (and optionally shows an activity indicator) and you get to see the
result. With this method you already get see part of the result even before the actual loading fase,
which could easily confuse users by letting them think the page is already done but nothing has
changed.

I agree that you should be careful applying this technique. But the clicking of the link is done
instantly, so the user would see the page loading immediately, thus he/she wouldn't think the page
is done. This technique works best if your pages are speedy enough, but can use just a bit more
oomph.
