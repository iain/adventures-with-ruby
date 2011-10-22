It took some late night coding, but I finished another plugin. It's a little helper that goes by the name of [no_value_helper](http://github.com/iain/no_value_helper). To install it, type: `./script/plugin install git://github.com/iain/no_value_helper.git`. It's not that big, but fully [tested](http://github.com/iain/no_value_helper/tree/master/spec/no_value_helper_spec.rb), which may save you some time.

It changes:

    <%= @user.name.blank? ? 'no value' : h(@user.name) %>

Into:

    <%= show(@user.name, :h) %>

But wait! There is more! This method can accept blocks too and rescue you from those pesky nils! Keep on reading!

### The problem I wanted to solve

This Ruby on Rails plugin tries to solve a common pattern when showing
values from the database. If you want to show a nice message like 'no value'
when an optional attribute has been left empty, you usually need to do the
same thing over and over again:

    <%= @user.name.blank? ? 'no value' : @user.name %>

It gets even worse when it's about an optional relation, with some extra methods:

    <%= @user.daddy ? link_to(@user.daddy.name, @user.daddy) : 'no daddy' %>

### The solution: no_value_helper

So this plugin tries to shorten this:

    <%= show(@user.name) %>

Or the second example:

    <%= show(:link_to, @user.daddy) { @user.daddy.name } %>

Don't worry, NoMethodErrors will be caught for you. That is why we use a block
in this case.

For the exact usage, read the [specs](http://github.com/iain/no_value_helper/tree/master/spec/no_value_helper_spec.rb).

### Configuration

To translate the message, you can simply add the "no_value" key (no scope) to
your translation files.

    nl-NL:
      no_value: geen waarde

By default the message is encapsulated by an em-tag with the class 'no_value'.
To change this, set the class variable `@@no_value_text` with a lambda. This is
done so I18n.translate will work. Make an initializer
(in `config/initializers/no_value_helper.rb`), containing this:

    module NoValueHelper
      @@no_value_text = lambda { "something more to your liking" }
    end

You can also change how this plugin checks for empty values. By default this is
done with the method [blank?](http://apidock.com/rails/Object/blank%3F)
This means that empty strings are also treated as 'no value'. To change this,
set the class variable `@@no_value_check_method` to a lambda that does what you
want. Your initializer will look something like this:

    module NoValueHelper
      @@no_value_check_method = lambda { |value| value.nil? }
    end

### Some more examples

Here are some more examples to inspire you:

    <%= show(:l, :format => :long){@user.birthday} %>
    <%= show(@user.savings, :number_to_currency) %>
    <%= show(:simple_format){@user.contract.company.billing_address} %>
