As [promised](/domain-driven-design-building-blocks-in-ruby), here is an example of how to use the idea of services from Domain Driven Design to help you design your code better. Let's start with some theoretical stuff, before we dive into some example code.

### In Theory

Services are best defined by what they're not. They're not entities or value objects.  To recap: entities are identifiable objects, that have real meaning in your domain. This might be a user or a post (if you're making a blog). Value objects are objects that are not defined by their identity, but by their value. An address of a person is usually a good example. It doesn't matter which address object it really is, as long as it contains the data it is supposed to have. Services are none of these. Services do something with the entities in your domain.

A good example of services are classes. By their very nature, classes are services for initializing objects. In Ruby this is idea is emphasized by the fact that classes are objects too. They have state and behavior, just as any other Ruby object. But their behavior is always aimed at something else, not themselves. Services tend to have no state, or very little at the most.

What's the advantage of thinking of classes as being services? Well, in my opinion it leads you to organize your code better. Class methods are only allowed to do something with creating instances of that class. If they are not doing that, they shouldn't be class methods.

It also answers the question: where should this behavior go? If it's not obvious, it's probably a service. The 'fat model, skinny controller'-principle has gotten some news lately. This principle was invented because developers (me included) were putting too much logic into the controllers. It made the controllers skinny and readable; but it had the side affect that everybody jammed the behavior into their models (entities), making them big and unwieldy. Services will help you create small and manageable classes.

### In Practice

Time for an example. Suppose you have an admin interface which allows the user to find their entities in many different ways, filtering on attributes and ordering them around until he finds the entities he wants. It might be part of a advanced search box. This filtering business is an excellent candidate for a service.

There are many ways of making a filter service. I've made something similar to this recently. I'll start by making a basic filter, with nothing specific.

``` ruby
module Filter
  class Base

    class_inheritable_array :filters
    self.filters = []

    # Call filter to define which filters are available.
    # These will all be run in the order you specified
    def self.filter(*filters)
      self.filters.unshift(*filters)
    end

    # The params are the parameters you might have entered in your form.
    attr_reader :params
    def initialize(params)
      @params = params
    end

    # Get all filtered results. This is the public facing method that
    # you'd want to call when getting the results of the filter.
    def all
      apply_filters
      scope
    end

    private

    # As part of the contract, set the default scope by overriding this method.
    def scope
      raise NotImplementedError
    end

    # Run all the filters, specified in subclasses.
    def apply_filters
      filters.each { |filter| send(filter) }
    end

    # Probably every filter should be able to paginate the results.
    # remember to call pagination last, because will_paginate won't return
    # a real ActiveRecord::Relation object.
    def pagination
      @scope = scope.paginate(:page => page, :per_page => per_page)
    end

    def page
      params[:page] || 1
    end

    def per_page
      params[:per_page] || 20
    end

    # Similar to pagination, sorting is something common to all filters,
    # The default order is :id, because that will be available on every
    # model. You can override it easily however.
    def sort(default = :id)
      @scope = scope.order(params[:order] || default)
      @scope = scope.reverse_order if params[:direction] == 'desc'
    end

  end
end
```

Now, you can make filters for every model. This means creating a class that inherits from this base class and implementing the simple contract we put in place. I'll use the (t)rusty Post model as an example implementation.

``` ruby
module Filter
  class Posts < Base

    # Here I define the filter methods that will be used for posts.
    filter :published, :by_name, :sort, :pagination

    # The default scope for posts is a plain Post class without any scope added.
    # You can apply some permissions here, for instance.
    def scope
      @scope ||= ::Post
    end

    # Only show published posts, when the 'only_published' checkbox has been
    # checked in the form.
    def published
      @scope = scope.published if params[:only_published] == '1'
    end

    # Provide a simple name field to filter on the name of the post
    def by_name
      if params[:name].present?
        @scope = scope.where('name LIKE ?', "%#{params[:name]}%")
      end
    end

    # I want to sort by the published_at column by default
    def sort(default = :published_at)
      super(default)
    end

  end
end
```

To use this filter, call it from the controller:

``` ruby
class Backend::PostsController < ApplicationController

  respond_to :html, :json, :xml

  def index
    @posts = Filter::Posts.new(params[:filter]).all
    respond_with @posts
  end

end
```

As you can see, this places the logic of filtering in its proper place. It's not part of the model, since it's not part of initializing objects, or behavior of individual post objects. It's a separate service, doing something with something else.

These services are incredibly easy to make. Just think about the objects it's trying to handle. These are probably the arguments of your initializer. Store those methods with an instance variable. All methods you create do something with either these objects or call methods that do so.

Don't forget to run [reek](http://wiki.github.com/kevinrutherford/reek/) on your code to see if you have any Low Cohesion or Feature Envy warnings. If you get any, than that method probably doesn't belong here, or you've got you're initial parameters wrong.


### Some bonus material


If you wish to simplify the interface even further, you can create a class method on the service to make it even easier (that's a service to create a service, so to speak).

``` ruby
module Filter
  class Base

    def self.all(*args)
      new(*args).all
    end

    # ... rest of the base class ...

  end
end
```

This reduces the connascence needed to use the service. Not really needed here, but it's a nice way of cleaning up your interface.

You might ask where do I put this into my Rails application. I make a folder `app/services` and (because I use RSpec) a folder named `spec/services`. If you use autotest, you need to tell it to pick up changes in these directories. You'll need to add the file `.autotest` to your application root folder, containing this bit of code to do the mapping:


``` ruby
Autotest.add_hook :initialize do |at|
  at.add_mapping(%r%^spec/(.*)_spec\.rb$%) { |filename, _| filename }
  at.add_mapping(%r%^app/(.*)\.rb$%) { |_, m| ["spec/#{m[1]}_spec.rb"] }
end
```
