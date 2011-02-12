Ruby on Rails is a fine framework. It uses Ruby which is beautiful programming language. Everything is an object in Ruby, and the [block structure](http://poignantguide.net/ruby/chapter-4.html#section4) allows you to do marvelous stuff with it. The Rails team is well aware of this and uses it, making Rails a great partner in crime. I still remember the first time I viewed the migration for creating a new database table:

<pre lang="rails">
create_table "users" do |t|
  t.column :name, :string, :limit => 40
  t.column :email, :string
  # etc
end
</pre>

I almost didn't recognize it at first. I didn't know Ruby back then, I just did what was necessary to make it work without looking at what it does. But take a good look at what it really does. It creates a table and gives you an object for you to play with. Within the block you can edit the properties of the thing you're creating in small readable lines. Ruby itself is full of these functions. Iterators are probably the best examples. What would any Ruby programmer do without <tt>[each](http://www.ruby-doc.org/core/classes/Hash.html#M002889)</tt>, <tt>[select](http://www.ruby-doc.org/core/classes/Hash.html#M002900)</tt> and <tt>[sort](http://www.ruby-doc.org/core/classes/Hash.html#M002893)</tt>? These blocks are arguably one of the nicest features in Ruby.

It's good to know that Rails incorporates this feature. Although I find it lacking in the view part. Sure you'll use methods like `each`, but think of all the helper-methods out there. Usually they are single methods doing some stuff and returning some HTML. Nice, but a bit cumbersome. Not that you'd need anything more complicated for creating a link or an image, but there is hardly anything 'sweet' going on in the views.

Then there are forms. Forms form the center of any web application, certainly Rails-made applications. In the views at least. Rails gives us the <tt>[form_for](http://api.rubyonrails.com/classes/ActionView/Helpers/FormHelper.html#M000920)</tt> and <tt>[form_tag](http://api.rubyonrails.com/classes/ActionView/Helpers/FormTagHelper.html#M001036)</tt> methods. These work in rather the same way as the migrations, giving you an form-object to play with. With this form object you can create all kinds of fields. Consider this simple form:

    <% form_for(@user) do |form| %>
      <p>
        <%= form.label(:name, 'your name:') %>
        <%= form.text_field(:name) %>
      </p>
      <p>
        <%= form.label(:password, 'your password:') %>
        <%= form.password_field(:password) %>
      </p>
    <% end %>

You might think: "That's rather neat!" and it is! But it is still lacking a lot. For once it's not DRY. You can correct that by making your own form builder, moving stuff to partials and a lot of other great examples float around the web waiting to be implemented. But something strikes me here. If the form is an object, why aren't fields? Why don't we apply the same principle here? Fields can have a lot of properties that would make the block-with-object method a nice solution. A field may have label, but also a description, some javascript validation, it can be a required field. A field my have multiple fields in it, like multiple checkboxes or radiobuttons. A block-with-object method for your fields might look like this:

    <%= form.create_field(:name) do |field|
      field.type = :text_field
      field.label = 'Name'
      field.required!
      field.description = 'Please enter your name here. It may only contain alphanumeric characters and underscores'
    end %>

    <%= form.create_field(:category_ids) do |field|
      field.label = 'Select some categories'
      field.type = :checkboxes
      field.add_options do |opt|
        opt.add 1, 'foo'
        opt.add 2, 'bar'
      end
    end %>

I hope you agree with me that this is much more readable and editable. It trades of long lines for more shorter lines which is a good trade-off. If you're using Haml for your views it's even more important to have short lines than in ERB. In Haml you can't easily break up lines so short lines of code is vital to the readability of your views. Views naturally have the tendency to become hard to follow and ugly, so it is recommended that important and complex parts of it (mainly views) stay easy and readable. Readability helps your maintainability. I am currently making this kind of form builder, so if you have any suggestions, please do!

But why stop here? Forms are not the only part which involves a lot of HTML and repetitive coding. Website often include blocks in a sidebar which are totally suited for this kind of solution. These are the days of glossy website designs, in the world of Web 2.0 every angle is softened or rounded. Sometimes this asks for a lot of HTML, building divs into divs. I'm a fan of Haml for making this easy, but you need a way to shorten lines, and in some way 'metaprogram' your HTML. At the risk of [sounding ](http://blog.thinkrelevance.com/2008/4/1/relevance-raises-3-6-million-from-spelvin-capital) '[Java-ish](http://blog.zenspider.com/2008/04/id-die-of-typing.html)', I'd say it would be better to build an extra layer of abstraction into the so trusty MVC. In your view you decide what goes where, what your lines are and which fields are available. Above it lies an HTML layer which translates it to whatever your website is designed to look like. A view gets split in two: a structural layer and a design layer. If thought out well you can even change one layer without the need to change the other.

This might not be your solution. Your website might be too small to make such a difference. But it's worth thinking about it when you're building something. If you're making a helper-method, and you find yourself in need of a lot (say, more than 2) arguments, consider making a small object with some accessors to making this easy. Here is something to help you on your way:

<pre lang="rails">
# in your view, traditional way (which can get very long, depending on the number of arguments):
<%= small_menu(:title => 'Monkey', :foo => 'bar') %>

# with a small helper class and a block structure it may become:
<%= small_menu do |sm|
  sm.title = 'Monkey'
  sm.foo = 'bar'
end %>

# you'll need this in your helper for that:
module SomeHelper

  def small_menu
    sm = SmallMenu.new
    yield sm
    # construct your html here, using parameters from the sm-object
  end

end

# in the same helper (only if it's short) or in another file (helper or lib)
class SmallMenu
  attr_accessor :title, :link, :partial, :foo
end
</pre>

By the way, if you haven't seen it yet, you should watch [Railscast episode 101](http://railscasts.com/episodes/101) for another nice way to incorporate classes into your helpers.
