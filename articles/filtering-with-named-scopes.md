Suppose you have an index page with people and you want to have a series of neat filters to show a selection of people. For example only the people still alive of only the adults. How would one do that?

I like the method of using a [named_scope](http://apidock.com/rails/ActiveRecord/NamedScope/ClassMethods/named_scope) and delegating to specified filters. This way, you can structure your filters properly and get clean URLs. Also, you can chain other named scopes to the filter.

This is an example of how I would do that.

### The view

In your index view, add a list of all filters:

    %h3= t(:people, :scope => :filter_titles)
    %ul
      - Person.available_filters.each do |filter|
        %li= link_to t(filter, :scope => [:filter_names, :people]), people_path(:filter => filter)

This will generate links that go to your index page (e.g. `/people?filter=adults`). You can even make a route that will clean up your views even more.

    map.connect "/people/filter/:filter", :controller => "people", :action => "index"

I use i18n to get the displayed link text for each link, so my locale file might look something like:

    en:
      filter_titles:
        people: Select a subset
      filter_names:
        people:
          deceased: Select deceased people
          alive: Select people that are (still) alive
          adults: Select people over 18

### The controller

Add the `named_scope` to your query:

    def index
      @people = Person.filter(params[:filter]).paginate(:page => params[:page])
    end

### The model

Here's the interesting stuff. Define the available filters as a class method:

    def self.available_filters
      [ :deceased, :alive, :adults ]
    end

Then, define class methods for each those filters, specifying what they need to do. I like to prepend them with "`filter_`", so it shows more intent. You can go crazy with these filter methods if you'd like. Just return valid [ActiveRecord find-options](http://apidock.com/rails/ActiveRecord/Base/find/class).

    def self.filter_deceased
      { :conditions => "deceased_on IS NOT NULL" }
    end

    def self.filter_alive
      { :conditions => "deceased_on IS NULL" }
    end

    def self.filter_adults
      { :conditions => ["birthday <= ?", 18.years.ago.to_date] }
    end

And finally, add the named scope that uses these filters:

    named_scope :filter, lambda { |f| available_filters.include?(f) ? send("filter_#{f}") : {} }

We check to see if the filter is available, excluding any invalid filter. Also, by default no filter is given from the controller. Then `params[:filter]` will be `nil` and so it won't try to call `Person.filter_`. You can replace the empty hash with a default filter if you like.

### Conclusion

These predefined filters can really help the usability of your new fancy web application. And I like the code too, because it looks very clear and it's easy to test.

Named scopes can get quite messy, certainly if you use a lambda and some logic. Delegating the body of the lambda to a class method is a good idea. Just be sure that the method returns a hash of some sort.

    named_scope :foo, lambda { |*args| foo_parameters(*args) }

You can make this into a named_scope generator even, but I'll save that for another time and post. Also, stay tuned for the encore: DRYing up the code for re-use!
