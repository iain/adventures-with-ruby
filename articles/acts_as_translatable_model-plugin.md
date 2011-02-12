After a long day in the train today, I extracted the I18n functionality from ActiveRecord so its applicable to any class. This can be especially handy if the source of the data is different, e.g. LDAP. Just install the plugin and add one line to your class to make it translatable:

    ./script/plugin install git://github.com/iain/acts_as_translatable_model

---

    class User
      acts_as_translatable_model

      attr_accessor :name, :password
    end

Now you can do <a href="http://iain.nl/2008/09/translating-activerecord/">familiar things</a> with the class, just as you would do with normal ActiveRecord models. <!--more-->Supply a translation:

    nl-NL:
      activerecord:
        models:
          user: gebruiker
        attributes:
          user:
            name: naam
            password: wachtwoord

---

    >> User.human_name
    => "gebruiker"
    >> User.human_attribute_name("name")
    => "naam"

Of course, you can use inheritance, just as you would use Single Table Inheritance (STI).

It also works nicely together with <a href="http://iain.nl/2008/09/form-labels-in-rails-22/">i18n_label</a>. A simple example:

    %h1= translate :please_login
    - form_for(User.new) do |f|
      = f.label :name
      = f.text_field :name
      = f.label :password
      = f.password_field :password
      = submit_tag( translate(:login) )

Hopefully, this will make your life a little bit easier.
