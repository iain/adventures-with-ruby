Want to build a quick website or backend? Want to make it look good, but without adding too much
effort in it? Then this recipe is for you!

The [jQuery UI framework](http://jqueryui.com) contains some nice styles and some nice javascript
to accompany it. But the class names you're ought to be using are awkward. Nobody wants to add
"ui-widget-header" to their classes. We have standards; we want semantical html and css, even if we
don't want to be doing much styling ourselves.

Editing the css file that jQuery UI gives you is not an option; that would be a hideous mess even
before we get started. Luckily, [Sass](http://sass-lang.com) can help us. Sass introduced the
"`@extend`" method since version 3, which we can (ab)use.

We need to convert the css file jQuery gave us to Sass. I'm a big fan of sass, not scss, so I'll be
using that:

``` bash
sass-convert --from css --to sass path/to/jquery-ui-1.8.2.custom.css > app/stylesheets/_jquery_ui.sass
```

I've included an underscore so it won't be compiled to a real css file when I run my application.
I've also configured Sass to load my sass files from `app/stylesheets`.

Next, create your own sass/scss file and use `@extend`:

In sass:

``` sass
@import jquery_ui

.project-header
  @extend .ui-widget
  @extend .ui-widget-header
  @extend .ui-corner-all
```

In scss:

``` scss
@import "jquery_ui";

.project-header {
  @extend .ui-widget;
  @extend .ui-widget-header;
  @extend .ui-corner-all;
}
```

Now you just need to add the class "`project-header`" to the appropriate HTML element, include the
compiled "screen.css" tag in your layout and you're done!

Be sure to use the javascript too, for nice interactions. The javascript will add classes
dynamically to certain elements. They will still work.

So what really happens? Well, `@extend` appends your own selector to the jQuery selector you
specified. So the compiled jQuery css would've looked like this before:

``` css
.ui-widget-header {
  border: 1px solid #aaaaaa;
  /* more... */
}
```

But after doing our `@extend`-trick, it will now compile to:

``` css
.ui-widget-header, .project-title {
  border: 1px solid #aaaaaa;
  /* more... */
}
```

Sass parsing is incredibly smart. Really smart. The original jQuery css will be changed
automatically. Awesome! And without hardly any effort from my side!

For more awesomeness in styling: Have a look at [compass](http://compass-style.org). It will be
worth your time!

