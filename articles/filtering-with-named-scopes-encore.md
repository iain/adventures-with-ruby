In my previous post, I talked about making filters using named scopes. To summorize:

<blockquote>
I like the method of using a named_scope and delegating to specified filters. This way, you can structure your filters properly and get clean URLs. Also, you can chain other named scopes to the filter.</blockquote>

If you find yourself making an administrative web application, with many tables and filters, here's an example to make it a little more DRY.
<!--more-->
<h2>Making a partial</h2>

First, make the filters a partial, in something like <tt>app/views/shared/_filters.html.haml</tt>.

    %h3= t(model_name, :scope => :filter_titles)
    %ul
      - model_class.available_filters.each do |filter|
        %li= link_to t(filter, :scope => [:filter_names, model_name]), url_for(params.merge(:filter => filter))

I've changed the translate-calls a bit, so they work with different models.

<h2>A helper method</h2>

Then, create a helper method:

    def show_filters_for(model_name)
      render :partial => "shared/filters",
             :locals => { :model_name => model_name, :model_class => model_name.to_s.camilze.constantize }
    end

Now you can render the filters like this:

    = show_filters_for :person

<h2>And a module</h2>

On the model side, you can make a module, probably in <tt>lib/chainable_filters.rb</tt>.

    module ChainableFilters

      def self.extended(model)
        model.named_scope :filter, lambda { |f|
          model.available_filters.include?(f) ? model.send("filter_#{f}") : {}
        }
      end

      def available_filters
        self.methods.select { |m| m =~ /^filter_/ }.map { |m| m[7..-1].to_sym }
      end

    end

Use it in a specific model, by extending with the module you just made:

    class Person < ActiveRecord::Base
      extend ChainableFilters
    end

Or just every ActiveRecord class, by creating an initializer file (i.e. <tt>config/initializers/chainable_filters.rb</tt>):

    ActiveRecord::Base.extend ChainableFilters

Now, that is some nice meta-programming, if you ask me! ;)
