Yes, I've written another plugin for Rails. It's about so called root tables. It seem to be making them often. I want a list with options to choose from and some easy way to manage that list, which is a tedious task. That's why I made a [plugin](http://github.com/iain/root_table) to do this for me.

### What I have so far is:

* Automatic validations and relations
* Completely configurable, with sensible defaults
* A management interface
* Works with [acts_as_list](http://github.com/rails/acts_as_list) and supports drag and drop sorting
* I18n support

### Let's take a tour of it's usage.

Install acts_as_list, if you want to:

    ./script/plugin install git://github.com/rails/acts_as_list.git

Install root_table:

    ./script/plugin install git://github.com/iain/root_table.git

Make a model that needs a list to choose from, like a product that has a category:

    ./script/genetate model Product name:string category_id:integer

Make a model for the root table, category:

    ./script/generate model Category name:string position:integer

Make category a root table for product:

    class Category < ActiveRecord::Base
      root_table_for :product
    end

And let the product model know as well what is happening:

    class Product < ActiveRecord::Base
      has_root_table :category
    end

Let's add a configured root table for good measure. Let's convert the User-model to a root table. User is not a list, and doesn't have a `name`-field to recognize it, nor does it have a position field. It requires some options to make it work.

    class User < ActiveRecord::Base
      root_table_for :product, :to => :last_edited_by,
          :validate => false, :field => :login
    end

And update the product model again:

    class Product < ActiveRecord::Base
      has_root_table :category
      has_root_table :user
    end

The relation is called `last_edited_by`, it doesn't add any validations and the displayed (and thus sorted) field is `login` instead of `name`. It doesn't have position field, nor do I provide it, so it'll sort on `login` and won't be manually sortable, as we'll se in a bit.

<small>Using the User model might not be the best example, but you'll get the point.</small>

### Management in a Rails Engine

Visit the management interface at `http://localhost:3000/root_tables` and see something like this:

<img src="/root_tables_path.png" alt="root_tables_path" title="root_tables_path" width="508" height="339" class="alignnone size-full wp-image-478" />

Since User has no position field, you'll end up with a simple scaffold-like management screen for it:

<img src="/root_table_contents_pathuser.png" alt="root_table_contents_path(user)" title="root_table_contents_path(user)" width="508" height="339" class="alignnone size-full wp-image-479" />

However, the Category model does have a position, so the interface has drag and drop functionality:

<img src="/root_table_contents_pathcategory.png" alt="root_table_contents_path(category)" title="root_table_contents_path(category)" width="508" height="339" class="alignnone size-full wp-image-480" />

It has a very simple new and edit screen, just as you would with scaffold:

<img src="/edit_root_table_contents_path.png" alt="edit_root_table_contents_path" title="edit_root_table_contents_path" width="508" height="339" class="alignnone size-full wp-image-481" />

This is all done with a layout that Rails scaffold generates. If you have your own layout it might look completely different. The management pages are a Rails engine. This means that you can override any file by creating a file with the same name in your `app`-directory. Have a look at the code to see which files you can override.

Also, to enable the drag and drop interface, you'll need to have prototype included. If you don't want prototype be loaded everywhere, I've made it so that only drag and drop pages load the javascript. Please add <tt><%= yield(:head) %></tt> to your html header.

You can also override views on a table basis. That means that you might want a view that is different just in case of one table. The form for new users might want to have more fields than just the login field, but also include password fields. Create a view for that in `app/views/root_table_contents/new_user.html.erb`. Available for override per model are index, new and edit.

### Using it elsewhere

But we're not there yet. Now we've built a root table and filled it, we need to use it somewhere. The plugin provides a `root_table_select` helper, that renders a drop down. The first parameter is the root_tables (real) name, it figures the rest out automatically. You can pass any options as the options you would pass the other select helpers. Here's an example:

    <% form_for @product do |f| %>
      <p>
        <%= f.label :category_id %><br />
        <%= f.root_table_select :category, :include_blank => true %>
      </p>
    <% end %>

Also for showing a delegate method is provided. This is how you can show the category name:

    @product.category_name

That about wraps it up for [root_table](http://github.com/iain/root_table). Please provide me with feedback and report any bugs and improvements. You can use the comments on my blog, or the [issues page on github](http://github.com/iain/root_table/issues).

### Update!

I've made some tiny updates, most importantly reducing the amount of magic. Rails does a very nice job of lazy loading your models which can lead to some strange errors with the previous version of my plugin. These should be fixed now.

### Lessons learned:

* A model does not know another model exist in development environment. Mentioning a model is enough to trigger Rails autoload and even constantizing a string works. Sweet!
* Don't require a model again during a request. Some models will break. I found this to be the case with the session class needed by AuthLogic. Again, to know for sure that a model has been loaded, simply mention it in your code, usually that is enough.
* Tests are run in an environment very similar to production. I already knew that, but it's worth mentioning that a stable development environment is also essential and you might not catch that with unit tests alone.

