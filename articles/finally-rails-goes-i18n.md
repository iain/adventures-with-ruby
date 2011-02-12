It has been some time, I know. It was a busy time. Since my last post I started working at [Finalist IT Group](http://finalist.com/), an exciting company doing exciting projects. Right now I'm doing a very demanding project for Eindhoven city council, which is quite far away from my home (well, in Holland it is anyway).

But time hasn't stopped. Ruby on Rails is busy advancing to version 2.2. One new feature in the upcoming Rails version has caught my eye and my undivided love and attention. It's the I18n-module built into Rails! It is already available if you're running edge.

Rails 2.2 ships with it's language elements already indexed and a simple backend (called SimpleBackend) for handling translations. The whole idea is to keep it as simple as possible so any developer can implement their own way of doing the i18n-dance. The SimpleBackend keeps it translations in memory. Soon a new version of Globalize will arrive for storing translation in a database and no doubt a gettext based backend will appear soon too.

Using the SimpleBackend, translating your database is dead easy. Amongst it's features are (in no particular order):

<ul>
  <li>Scoping, for sorting your keys and thus avoiding name clashes</li>
  <li>Bulk look up of multiple translations</li>
  <li>Default translations for when the translation hasn't been found</li>
  <li>Interpolation, inserting values in the middle of translations</li>
  <li>Pluralization, handling multiple translations depending on a value being plural or singular</li>
  <li>Having multiple default translation, for using another keys as default</li>
  <li>Localization of dates and times</li>
</ul>

I can't go into each features into one post, so I'll be posting more in a while. First, let us take a look at the basics:

<pre lang="rails">
I18n.store_translations( 'en-US', { :hello => 'hello' } )
I18n.store_translations( 'nl-NL', { :hello => 'hallo' } )
I18n.translate( :hello ) # => "hello" (en-US is the default locale)
I18n.locale = 'nl-NL'
I18n.translate( :hello ) # => "hallo"
</pre>

The big advantage is that I18n is now baked into Rails, so all you're favorite "railties" will automagically be translated (en-US translations are of course default and provided for, so you don't have to use I18n if you don't want to). Amongst others, cool stuff like date-formats, number and currency formatting and default ActiveRecord error messages are indexed. Here is an example:

<pre lang="rails">
I18n.store_translations( 'nl-NL', { :support => { :array => { :sentence_connector => 'en' } } } )
%w{a b c}.to_sentence # => "a, b, en c" (look mama, no I18n.translate call!)
</pre>

In date(and -time) objects you need to call the method localize to translate. You can define your own preferred formats too, so no more need for those ugly strftime method calls in your code.

<pre lang="rails">
I18n.localize( Time.now, :format => :long ) # "vrijdag, 8 augustus 2008, 20:51:15"
</pre>

ActiveRecord column names and error messages are easily translated too! You just have to know the proper scope. What you need to do is store translations in these scopes and Rails will automatically use it for you. In my opinion it is a bit of mess. Hopefully it'll be changed to something less scattered soon.

In this example, I have a model called Post and it has an attribute named 'title'.

<strong style="color: red;">Update!</strong> The proper way to translate ActiveRecord is described [here!](/translating-activerecord/)

<pre lang="rails">
I18n.store_translations( 'en-US', {
  :active_record => {
    :error => {
      :header_message => "default message for error_messages_for",
      :post => "When the model name is not what you like"
    },
    :error_messages => {
      :blank => "your default 'cannot be blank' message",
      :custom => {
        :post => {
          :title => {
            :blank => "error message for @post.title only"
          }
        }
      }
    },
    :human_attribute_names => {
      :post => {
        :title => "Translation of the column name"
      }
    }
  }
} )
I18n.translate :'active_record.human_attribute_names.post.title'
# => "Translation of the column name"
</pre>

Unfortunately there isn't a good list of which translations are available. I will try to make one soon.

There are some limitations to the default I18n implementation. How you want to incorporate it in your site is completely up to you. Also, how and where you keep your translations has not been implemented. So you have to load a bunch of files yourself in which you keep translations.

But it gets easier. I made a plugin, called [i18n_yaml](http://github.com/iain/i18n_yaml/), which handles all of this for you. It is not a different backend, but rather an extension to SimpleBackend. It stores its translation files in yaml-files found in app/locales. It also provides a before_filter to find the appropriate locale. In other words: everything you need to make SimpleBackend useful! Like Rails 2.2, it is not finished yet, but you can have a go at it of course.

Would you like to contribute to i18n? Join the [mailinglist](http://groups.google.com/group/rails-i18n). Rails i18n also launched it's own website: [rails-i18n.org](http://rails-i18n.org/). There are a number of tutorials and articles already available, listed [here](http://rails-i18n.org/wiki).

This concludes the first part of the Rails i18n introduction. I'll be posting some more insights into i18n soon, so stay tuned!

<h3>Update:</h3>

Locate the locale.yml files in Rails to find all possible translations. Here is [a pastie](http://pastie.org/306532) with everything translated to Dutch.
