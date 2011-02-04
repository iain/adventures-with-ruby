Suppose you have an index page with people and you want to have a series of neat filters to show a selection of people. For example only the people still alive of only the adults. How would one do that?

I like the method of using a <a href="http://apidock.com/rails/ActiveRecord/NamedScope/ClassMethods/named_scope" target="_blank">named_scope</a> and delegating to specified filters. This way, you can structure your filters properly and get clean URLs. Also, you can chain other named scopes to the filter.

This is an example of how I would do that.
<!--more-->
<h2>The view</h2>

In your index view, add a list of all filters:

[sourcecode language='ruby']
%h3= t(:people, :scope => :filter_titles)
%ul
  - Person.available_filters.each do |filter|
    %li= link_to t(filter, :scope => [:filter_names, :people]), people_path(:filter => filter)
[/sourcecode]

This will generate links that go to your index page (e.g. <tt>/people?filter=adults</tt>). You can even make a route that will clean up your views even more.

[sourcecode language='ruby']map.connect "/people/filter/:filter", :controller => "people", :action => "index"[/sourcecode]

I use i18n to get the displayed link text for each link, so my locale file might look something like:

[sourcecode language='js']
en:
  filter_titles:
    people: Select a subset
  filter_names:
    people:
      deceased: Select deceased people
      alive: Select people that are (still) alive
      adults: Select people over 18
[/sourcecode]

<h2>The controller</h2>

Add the <tt>named_scope</tt> to your query:

[sourcecode language='ruby']
def index
  @people = Person.filter(params[:filter]).paginate(:page => params[:page])
end
[/sourcecode]

<h2>The model</h2>

Here's the interesting stuff. Define the available filters as a class method:

[sourcecode language='ruby']
def self.available_filters
  [ :deceased, :alive, :adults ]
end
[/sourcecode]

Then, define class methods for each those filters, specifying what they need to do. I like to prepend them with "<tt>filter_</tt>", so it shows more intent. You can go crazy with these filter methods if you'd like. Just return valid <a href="http://apidock.com/rails/ActiveRecord/Base/find/class" target="_blank">ActiveRecord find-options</a>.

[sourcecode language='ruby']
def self.filter_deceased
  { :conditions => "deceased_on IS NOT NULL" }
end

def self.filter_alive
  { :conditions => "deceased_on IS NULL" }
end

def self.filter_adults
  { :conditions => ["birthday <= ?", 18.years.ago.to_date] }
end
[/sourcecode]

And finally, add the named scope that uses these filters:

[sourcecode language='ruby']
named_scope :filter, lambda { |f| available_filters.include?(f) ? send("filter_#{f}") : {} }
[/sourcecode]

We check to see if the filter is available, excluding any invalid filter. Also, by default no filter is given from the controller. Then <tt>params[:filter]</tt> will be <tt>nil</tt> and so it won't try to call <tt>Person.filter_</tt>. You can replace the empty hash with a default filter if you like.

<h2>Conclusion</h2>

These predefined filters can really help the usability of your new fancy web application. And I like the code too, because it looks very clear and it's easy to test.

Named scopes can get quite messy, certainly if you use a lambda and some logic. Delegating the body of the lambda to a class method is a good idea. Just be sure that the method returns a hash of some sort.

[sourcecode language='ruby']
named_scope :foo, lambda { |*args| foo_parameters(*args) }
[/sourcecode]

You can make this into a named_scope generator even, but I'll save that for another time and post. Also, stay tuned for the encore: DRYing up the code for re-use!