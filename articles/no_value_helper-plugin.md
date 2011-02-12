It took some late night coding, but I finished another plugin. It's a little helper that goes by the name of <a href="http://github.com/iain/no_value_helper">no_value_helper</a>. To install it, type: <tt>./script/plugin install git://github.com/iain/no_value_helper.git</tt>. It's not that big, but fully <a href="http://github.com/iain/no_value_helper/tree/master/spec/no_value_helper_spec.rb" target="_blank">tested</a>, which may save you some time.

It changes:

    <%= @user.name.blank? ? 'no value' : h(@user.name) %>

Into:

<pre lang="rails"><%= show(@user.name, :h) %></pre>

But wait! There is more! This method can accept blocks too and rescue you from those pesky nils! Keep on reading!

### The problem I wanted to solve

This Ruby on Rails plugin tries to solve a common pattern when showing
values from the database. If you want to show a nice message like 'no value'
when an optional attribute has been left empty, you usually need to do the
same thing over and over again:

<pre lang="rails"><%= @user.name.blank? ? 'no value' : @user.name %></pre>

It gets even worse when it's about an optional relation, with some extra methods:

<pre lang="rails"><%= @user.daddy ? link_to(@user.daddy.name, @user.daddy) : 'no daddy' %></pre>

### The solution: no_value_helper

So this plugin tries to shorten this:

<pre lang="rails"><%= show(@user.name) %></pre>

Or the second example:

<pre lang="rails"><%= show(:link_to, @user.daddy) { @user.daddy.name } %></pre>

Don't worry, NoMethodErrors will be caught for you. That is why we use a block
in this case.

For the exact usage, read the <a href="http://github.com/iain/no_value_helper/tree/master/spec/no_value_helper_spec.rb" target="_blank">specs</a>.

### Configuration

To translate the message, you can simply add the "no_value" key (no scope) to
your translation files.

<pre lang="yaml">
nl-NL:
  no_value: geen waarde
</pre>

By default the message is encapsulated by an em-tag with the class 'no_value'.
To change this, set the class variable <tt>@@no_value_text</tt> with a lambda. This is
done so I18n.translate will work. Make an initializer
(in <tt>config/initializers/no_value_helper.rb</tt>), containing this:

<pre lang="rails">
module NoValueHelper
  @@no_value_text = lambda { "something more to your liking" }
end
</pre>

You can also change how this plugin checks for empty values. By default this is
done with the method <a href="http://apidock.com/rails/Object/blank%3F" target="_blank">blank?</a>
This means that empty strings are also treated as 'no value'. To change this,
set the class variable <tt>@@no_value_check_method</tt> to a lambda that does what you
want. Your initializer will look something like this:

<pre lang="rails">
module NoValueHelper
  @@no_value_check_method = lambda { |value| value.nil? }
end
</pre>

### Some more examples

Here are some more examples to inspire you:

<pre lang="rails">
<%= show(:l, :format => :long){@user.birthday} %>
<%= show(@user.savings, :number_to_currency) %>
<%= show(:simple_format){@user.contract.company.billing_address} %>
</pre>
