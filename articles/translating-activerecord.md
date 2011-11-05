**Updated October 10th, 2008 to be up to date with Rails 2.2 RC1 release.**

With Rails 2.2 releasing any day now, I want to show you how to translate ActiveRecord related
stuff. It is quite easy, once you know where to keep your translations. Here is a complete guide to
using all built in translation methods!


### Scenario

Suppose we're building a forum. A forum has several types (e.g. admin) of users and suppose we want
to make the most important users into separate models using Single Table Inheritance (sti). This
gives us the most complete scenario in showing off all translations:

``` ruby
class User < ActiveRecord::Base
  validates_presence_of :name, :email, :encrypted_password, :salt
  validates_uniqueness_of :email, :message => :already_registered
end

class Admin < User
  validate :only_men_can_be_admin
private
  def only_men_can_be_admin
    errors.add(:gender, :chauvinistic, :default => "This is a chauvinistic error message") unless gender == 'm'
  end
end
```

### Setting up

Make sure you're running Rails 2.2 or Rails edge (`rake rails:freeze:edge`)

Now let's translate all this into [LOLCAT](http://icanhascheezburger.com), just for fun. We need a
directory to place the locale files:

``` bash
mkdir app/locales
```

And we need to load all files as soon as the application starts. So we make an initializer:

``` ruby
# config/initializers/load_translations.rb
%w{yml rb}.each do |type|
  I18n.load_path += Dir.glob("#{RAILS_ROOT}/app/locales/**/*.#{type}")
end
I18n.default_locale = 'LOL'
```

This approach is recommended, because loading files is not something you want to do during the
request, when it should already be available. Setting you're locale like this is probably not
recommended, but it's easy, if you're just using one language.

### Translating models

Next, we're going to make some simple translation files. All ActiveRecord translations need to be in
the activerecord scope. So when starting your locale file, it starts with the locale name, followed
by the scope.

``` yaml
LOL:
  activerecord:
    models:
      user: kitteh
      admin: Ceiling cat
```

Let's try this out in `script/console`

``` ruby
User.human_name
# => "kitteh"
Admin.human_name
# => "Ceiling cat"
```

It's nice to know that the method `human_name` is used by error messages in validations too. But
we'll come to that in just a second.

If you didn't specify the translation of admin, it would have used the translation of user, because it inherited it.

### Translating attributes

We could append to the same file, but I choose to make a new file, because it keeps this post clean
and it's a bit easier to see how the scoping works.

``` yaml
LOL:
  activerecord:
    attributes:
      user:
        name: naem
        email: emale
```

And let's try this again:

``` ruby
User.human_attribute_name("name")
# => "naem"
Admin.human_attribute_name("email")
# => "emale"
```

Once again, you can see that single table inheritance helps us with this.

Both human_name and human_attribute cannot really fail, because if no translation has been
specified, it would return the normal humanized version. So if you're making an English site, you
don't really need to translate models and attributes.

### Translating default validations

Let's translate a few default messages:

``` yaml
LOL:
  activerecord:
    errors:
      messages:
        blank: "can not has nottin"
```

``` ruby
u = User.new
# => #<User id: nil, etc>
u.valid?
# => false
u.errors.on(:name)
# => "can not has nottin"
```

### Interpolation in validations

You have more freedom in your validation messages now. With every message you can interpolate the
translated name of the model, the attribute and the value. The variable 'count' is also available
where applicable (e.g. `validates_length_of`)

``` yaml
LOL:
  activerecord:
    errors:
      messages:
        already_registered: "u already is {{model}}"
```

``` ruby
u.errors.on(:email)
# => "u already is kitteh"
```

Remember to put quotes around the translation key in yaml, because it'll fail without it, when using
the interpolation brackets.

### Model specific messages

A message specified in the activerecord.errors.models scope overrides the translation of this kind
of message for the entire model.

``` yaml
LOL:
  activerecord:
    errors:
      messages:
        blank: "can not has nottin"
      models:
        admin:
          blank: "want!"
```

``` ruby
u.errors.on(:name)
# => "can has nottin"
a = Admin.new
# => #<Admin id: nil, etc>
a.valid?
# => false
a.errors.on(:salt)
# => "want!"
```


### Attribute specific messages

Any translation in the activerecord.errors.models.model_name.attributes scope overrides model
specific attribute- and default messages.

``` yaml
LOL:
  activerecord:
    errors:
      models:
        admin:
          blank: "want!"
          attributes:
            salt:
              blank: "is needed for cheezburger"
```

``` ruby
a.errors.on(:name)
# => "want!"
a.errors.on(:salt)
# => "is needed for cheezburger"
```

### Defaults

When you specify a symbol as the default option, it will be translated like a normal error message,
just like you've seen with `:already_registered`. When default hasn't been found, it'll try looking
up the normal key you have given. With `:already_registered`, that key has already been set by
Rails, because we're using `validates_uniqueness_of`.

When you specify a string as default value, it'll use this when no translations have otherwise been
found.

``` ruby
a.gender = 'f'
# => "f"
a.valid?
# => false
a.errors.on(:gender)
# => "This is a chauvinistic error message"
```

### Using error_messages_for

When you want to display the error messages in a model in a view, most people will user
error_messages_for. These messages are also translated. The message has a header and a single line,
saying how many errors there are. Here are the default English translations of these messages. I
will leave it up to you to translate it to LOLCAT. Win a lifetime supply of cheezburgerz* with this
mini-competition ;)

``` yaml
en-US:
  activerecord:
    errors:
      template:
        header:
          one: "1 error prohibited this {{model}} from being saved"
          other: "{{count}} errors prohibited this {{model}} from being saved"
        body: "There were problems with the following fields:"
```

There is one slight problem with the messages it displays. `error_messages_for` uses the
`errors.full_messages` in it's list. This means that the attribute names will be put before it. Of
course these will be translated with `human_attribute_name`, but it might not always be desirable.
In other languages than English it's sometimes hard to formulate a nice error message with the
attribute name at the beginning. This will have to be fixed in later Rails versions.

### Conclusion

I hope you'll agree with me that these translation options for ActiveRecord are really nice! This
is what we have been waiting for. Too bad I was a bit too late with my adjustments, so form labels
don't translate by default. I did build it, but Rails was already feature frozen by then. I will
probably post a plugin that adds this functionality. Same goes for a i18n version of scaffold.

Please keep coming back to my site, or add the RSS feed to your favorite reader.

Of course, stay in touch with the [i18n mailinglist](http://groups.google.com/group/rails-i18n). A
lot of people are putting a lot of effort into the project. New plugins and gems solving problems
problems rapidly. I18n is one of the more difficult things to do, so if you have a special insight
in a language, please contribute!

**Happy devving!**

PS. Damn! I wish I was in [Berlin](http://en.oreilly.com/railseurope2008/public/content/home) right now!


<p style="font-size: 40%">* invisible cheezburgerz only</p>

### Update

This post is old. Still, after 2 years, it still accounts for 10% of my daily traffic. How cool is
that? Seriously though, read the [official Rails guide](http://guides.rubyonrails.org/i18n.html) on
this subject, for up to date information!
