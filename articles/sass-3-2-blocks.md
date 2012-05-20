A lot of websites have side bars. On normal desktop browsers, this fits nicely. But
on smaller screens, it will create horizontal scrollbars. And those are a bad
user experience. Luckily, CSS supports `@media` directives that act on
different sizes.

Sass 3.2 is going to ship with an awesome new feature: blocks.  Just like Ruby.
Instead of `yield`, you use `@content`. The rest is exactly the same. You can
place anything inside your blocks: selectors (like `table.products`) and rules
(like `border: 1px solid gold`).

The [Sass
documentation](https://github.com/nex3/sass/blob/master/doc-src/SASS_REFERENCE.md#passing-content-blocks-to-a-mixin-mixin-content)
mentions that you can use it to specify it for IE6 compatibility, but I like it
most for making my design responsive. Just create a mixin that places the
`@content` inside the `@media` directive.

The following scss code defines mixins for small screens and big screens. You
could even go further and define 3 categories, really small screens for mobile
phones, medium sized screens like tablets and small desktop windows, and your
normal big layout.

``` scss
$site-width: 1000px;

@mixin small-screen {
  @media only screen and (max-width: $site-width + 99px) {
    @content;
  }
}

@mixin big-screen {
  @media only screen and (min-width: $site-width + 100px) {
    @content;
  }
}
```

I add around 100px, which makes the switch between big and small screen styling
happen a bit earlier. This makes it always have a bit of margin, which I like.

For smaller screens, it is common to make the site fill the width of the window
and place columns underneath each other. The following code does that.


``` scss
$grid-count: 12;

.container {
  @include big-screen {
    width: $site-width;
    margin: 0 auto;
  }
  @include small-screen {
    width: auto
  }
}
.column {
  @include big-screen {
    width: $site-width / $grid-count;
    float: left;
  }
  @include small-screen {
    width: auto;
    float: none;
  }
}
```

I have found that it with this approach, it is easiest to split the CSS into
layout and styling. The styling, like colors and font-size, is probably the
same on every screen, but the size, padding and floating of elements will
change depending on the screen size.

In this case, I'd like place the `@media` directive around the tags, creating a
clear distinction between layout for big and small screens:

``` scss
$grid-count: 12;

@include big-screen {
  .container {
    width: $site-width;
    margin: 0 auto;
  }
  .column {
    width: $site-width / $grid-count;
    float: left;
  }
}

@include small-screen {
  .container {
    width: auto;
  }
  .column {
    width: auto;
    float: none;
  }
}
```

It depends on your site, which approach works best for you. It will result in
the same CSS. The `@media` directive is not allowed nested. [Sass will
automatically correct
it](https://github.com/nex3/sass/blob/master/doc-src/SASS_REFERENCE.md#media-media)
if for you anyway. You got to love Sass for things like this!

I've seen some projects with really complicated mixins, taking in really
complicated arguments. This will definitely clean this up.
