**I made this into a plugin: [translatable_columns](/plugin-translatable_columns/).**

Dmitry [asked in the comments](/translating-activerecord/#comment-96) of my last post [about translating ActiveRecord](/translating-activerecord):

> Can you write about how to use translated columns of database in rails? For example we have table named ‘blog’, and I want to translate it on several languages: fr, en, ru. How to do that?

And although I don't think this is the way to go, I can of course demonstrate an easy way to do this, using I18n.

Here's the table definition:

    create_table :posts do |t|
      t.string :title_en, :title_nl, :title_fr, :title_de
      t.string :text_en, :text_nl, :text_fr, :text_de
    end

So what you'd want to do is read the currently selected locale and choose to write to the proper attribute depending on that.

    class Post < ActiveRecord::Base
      def title
        self[column('title')]
      end
      def title=(str)
        self[column('title')] = str
      end
    private
      def column(name)
        column_name = "#{name}_#{I18n.locale.split('-').first}"
        self.class.column_names.include?(column_name) ? column_name.to_sym : "#{name}_#{I18n.default_locale.split('-').first.to_sym}"
      end
    end

Now, you can treat Post as if it had a normal title attribute, but it would save to the proper column. If you don't have a column named for this attribute, it'll save or get the value of the default_locale.

So for instance you can do this in your edit view:

    <% form_for(@post) do |f| %>
      <%= f.text_field :title %>
    <% end %>

But when you have multiple columns that needs to be translated, even scattered through multiple models, it tends to be a boring and repeating business to add all those virtual attributes. So let's do some meta-programming, and clean up models!

First, make a file in the `RAILS_ROOT/lib` directory, called `load_translations.rb` and put in this Ruby meta-programming goodness/madness:

    module TranslatableColumns

      def translatable_columns(*columns)
        columns.each do |column|

          define_method column do
            self[self.class.column_translated(column)]
          end

          define_method "#{column}=" do |value|
            self[self.class.column_translated(column)] = value
          end

        end
      end

      def column_translated(name)
        column_name = "#{name}_#{I18n.locale.split('-').first}"
        self.column_names.include?(column_name) ? column_name.to_sym : "#{name}_#{I18n.default_locale.split('-').first.to_sym}"
      end

    end

Now all you have to to in the model is extend it with this module and specify which columns can be translated:

    class Post < ActiveRecord::Base
      extend TranslatableColumns
      translatable_columns :title, :text
    end

Still I'm not really fond of this. I can't find a good, sensible scenario where this would be the best option. I would rather go with an attribute called 'locale'. So let's look at that too.

    ./script/generate migration add_locale_to_post locale:string
    rake db:migrate

And add a named_scope to the models you want to be localized, like Post in this case, to get the proper locales and save it to whatever locale was selected at the moment, if it hasn't already been set any other way (you might want to make the user able to choose it when entering the post).

    class Post < ActiveRecord::Base
      named_scope :localized, { :conditions => { :locale => I18n.locale } } }
      before_save :store_locale
    private
      def store_locale
        self[:locale] ||= I18n.locale
      end
    end

Let's meta-program this one as well!

Get the proper posts, just call `Post.localized` or `Post.localized.find(params[:id])`. Note that I'm not using any translatable columns now. Just use normal columns and create multiple posts if you want more than one language for a post (e.g. create a Dutch one and a French one).

As you can see, I'm not using the translating functionality of I18n here. I just use I18n to know which locale to choose.
