I did some research into [i18n plugins for Ruby on Rails](http://agilewebdevelopment.com/plugins/category/8).  I found [Globalize ](http://wiki.globalize-rails.org/)not manageable enough, especially looking at substitution of values and pluralization. Click to globalize (http://www.lucaguidi.com/pages/click-to-globalize) didn't support substitution or pluralization.  Many (http://simple-localization.arkanis.de/) [others](http://agilewebdevelopment.com/plugins/i18n) used symbols as translation key, but that provided the same problem as Globalize.

So I turned to [Gettext](http://www.gnu.org/software/gettext/). Gettext uses .po- and .mo files, like a proper GNU application, which attracted me. But when it came to substitution, small parts, like link texts, were scattered through the language file. I had to come up with a little scheme.

So I wrote a simple plugin for Ruby on Rails. This plugin inspects a single string to get pluralization with substitution. The single string keeps the translation in one place.

Although I created this plugin for gettext, it can be used whenever you like. If you're not using gettext, `_("string").pluralize_for becomes "string".pluralize_for`... Simple enough...

I've opened a [google-code spot](http://code.google.com/p/pluralize-for-gettext/), so you can have a peak there, although I haven't gotten round to filling out every page there.

Learn how to install gettext in [this excellent guide](http://manuals.rubyonrails.com/read/chapter/105). Use this tip to get it [working with Rails 2.0](http://zargony.com/2007/07/29/using-ruby-gettext-with-edge-rails/).

### Installation

    ./script/plugin install http://pluralize-for-gettext.googlecode.com/svn/trunk/

And then rename `vendor/plugins/svn` to `vendor/plugins/pluralize_for_gettext`

### Examples

    <%=_('No posts ~~ Only one post ~~ You have {$N} posts!').pluralize_for(Post.count) %>

The example speaks for itself.

You can change the conditions for each part in the string:

    <%=_('~~$N==0: No posts ~~$N==1: Only one post ~~else: You have {$N} posts').pluralize_for(Post.count)%>

Note: The translator can change the logic for this, for languages with weird pluralization rules. ;)

Caution: It's being eval'ed, so always check language files (or ruby code) for any Ruby injections.

### Substituting more variables

Why not use the default sprintf-like function from rails? You'd get this:

    <%_('You have %d posts, view %s') % [ Post.count, link_to(_('more'), view_more_url)%>

You'd get multiple entries in you .po file, and just 'more' can't be translated differently according to the context. The point of this whole exercise was to keep text that appears in one place together in the .po-file.

More advanced, for entering links and stuff, simply use {1:your text} and pass a block to the function to manipulate the texts in anyway you like. The number becomes the id for the array, so be careful in how you use them.

    <%=_('No posts, create one by clicking {1:here} ~~ Only one post ~~ You have {$N} posts ~~$N&gt;6: You have {$N} posts, view {2:more}').pluralize_for(Post.count) do |i|
        i[1] = link_to(i[1], create_post_url) if i[1]
        i[2] = link_to(i[2], view_more_url) if i[2]
      %>

Which would result in the .po file:

    #: app/controllers/some_controller.rb:102
      msgid "No posts, create one by clicking {1:here} ~~ Only one post ~~ You have {$N} posts ~$N>6~ You have {$N} posts, view {2:more}"
      msgstr "Geen artikelen, {1:plaats een artikel} ~~ Slechts een artikel ~~ Je hebt {$N} artikelen ~$N>6~ Je hebt {$N} artikelen ({2:bekijk meer...})"

### Simple pluralizations

Perhaps you just want to specify a singular and plural for one word in the entire sentence:

    <%=_('You have {$N} {post|posts}').pluralize_for(Post.count)%>

English is simpler than many other languages, so the translator could change it into the more elaborate version:

    #: app/controllers/some_controller.rb:102
      msgid "You have {$N} {post|posts}"
      msgstr "~~$N==0: Helemaal geen artikelen ~~$N==1: U heeft een artikel ~~$N>1: U heeft {$N} artikelen"</pre>

### Nesting

You can nest any way you'd like, but keep it sane. Here's a nice example:

    "$N==0:No posts. {1:create one}.~~else:You have {1:{$N} new {post|posts}}...".pluralize_for(Post.count) do |i|
      i[1] =  link_to(i[1], url) if i[1]
      i[2] = link_to(i[2], other_url) if i[2]
    end
