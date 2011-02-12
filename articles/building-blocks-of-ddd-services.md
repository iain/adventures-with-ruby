As <a href="/domain-driven-design-building-blocks-in-ruby/">promised</a>, here is an example of how to use the idea of services from Domain Driven Design to help you design your code better. Let's start with some theoretical stuff, before we dive into some example code.

### In Theory

Services are best defined by what they're not. They're not entities or value objects.  To recap: entities are identifiable objects, that have real meaning in your domain. This might be a user or a post (if you're making a blog). Value objects are objects that are not defined by their identity, but by their value. An address of a person is usually a good example. It doesn't matter which address object it really is, as long as it contains the data it is supposed to have. Services are none of these. Services do something with the entities in your domain.

A good example of services are classes. By their very nature, classes are services for initializing objects. In Ruby this is idea is emphasized by the fact that classes are objects too. They have state and behavior, just as any other Ruby object. But their behavior is always aimed at something else, not themselves. Services tend to have no state, or very little at the most.

What's the advantage of thinking of classes as being services? Well, in my opinion it leads you to organize your code better. Class methods are only allowed to do something with creating instances of that class. If they are not doing that, they shouldn't be class methods.

It also answers the question: where should this behavior go? If it's not obvious, it's probably a service. The 'fat model, skinny controller'-principle has gotten some news lately. This principle was invented because developers (me included) were putting too much logic into the controllers. It made the controllers skinny and readable; but it had the side affect that everybody jammed the behavior into their models (entities), making them big and unwieldy. Services will help you create small and manageable classes.

### In Practice

Time for an example. Suppose you have an admin interface which allows the user to find their entities in many different ways, filtering on attributes and ordering them around until he finds the entities he wants. It might be part of a advanced search box. This filtering business is an excellent candidate for a service.

There are many ways of making a filter service. I've made something similar to this recently. I'll start by making a basic filter, with nothing specific.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#96cbfe">module</font>&nbsp;<font color="#ffffb6">Filter</font>
&nbsp;&nbsp;<font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Base</font>

&nbsp;&nbsp;&nbsp;&nbsp;class_inheritable_array <font color="#99cc99">:filters</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#99cc99">self</font>.filters = []

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># Call filter to define which filters are available.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># These will all be run in the order you specified</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#99cc99">self</font>.<font color="#ffd2a7">filter</font>(*filters)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#99cc99">self</font>.filters.unshift(*filters)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># The params are the parameters you might have entered in your form.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">attr_reader</font>&nbsp;<font color="#99cc99">:params</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">initialize</font>(params)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@params</font>&nbsp;= params
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># Get all filtered results. This is the public facing method that</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># you'd want to call when getting the results of the filter.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">all</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;apply_filters
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;scope
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">private</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># As part of the contract, set the default scope by overriding this method.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">scope</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">raise</font>&nbsp;<font color="#ffffb6">NotImplementedError</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># Run all the filters, specified in subclasses.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">apply_filters</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;filters.each { |<font color="#c6c5fe">filter</font>|&nbsp;send(filter) }
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># Probably every filter should be able to paginate the results.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># remember to call pagination last, because will_paginate won't return</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># a real ActiveRecord::Relation object.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">pagination</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@scope</font>&nbsp;= scope.paginate(<font color="#99cc99">:page</font>&nbsp;=&gt; page, <font color="#99cc99">:per_page</font>&nbsp;=&gt; per_page)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">page</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;params[<font color="#99cc99">:page</font>] || <font color="#ff73fd">1</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">per_page</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;params[<font color="#99cc99">:per_page</font>] || <font color="#ff73fd">20</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># Similar to pagination, sorting is something common to all filters,</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># The default order is :id, because that will be available on every</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># model. You can override it easily however.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">sort</font>(default = <font color="#99cc99">:id</font>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@scope</font>&nbsp;= scope.order(params[<font color="#99cc99">:order</font>] || default)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@scope</font>&nbsp;= scope.reverse_order <font color="#6699cc">if</font>&nbsp;params[<font color="#99cc99">:direction</font>] == <font color="#336633">'</font><font color="#a8ff60">desc</font><font color="#336633">'</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font></pre>

Now, you can make filters for every model. This means creating a class that inherits from this base class and implementing the simple contract we put in place. I'll use the (t)rusty Post model as an example implementation.

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#96cbfe">module</font>&nbsp;<font color="#ffffb6">Filter</font>
&nbsp;&nbsp;<font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Posts</font>&nbsp;&lt; <font color="#ffffb6">Base</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># Here I define the filter methods that will be used for posts.</font>
&nbsp;&nbsp;&nbsp;&nbsp;filter <font color="#99cc99">:published</font>, <font color="#99cc99">:by_name</font>, <font color="#99cc99">:sort</font>, <font color="#99cc99">:pagination</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># The default scope for posts is a plain Post class without any scope added.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># You can apply some permissions here, for instance.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">scope</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@scope</font>&nbsp;||= ::<font color="#ffffb6">Post</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># Only show published posts, when the 'only_published' checkbox has been</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># checked in the form.</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">published</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@scope</font>&nbsp;= scope.published <font color="#6699cc">if</font>&nbsp;params[<font color="#99cc99">:only_published</font>] == <font color="#336633">'</font><font color="#a8ff60">1</font><font color="#336633">'</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># Provide a simple name field to filter on the name of the post</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">by_name</font>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">if</font>&nbsp;params[<font color="#99cc99">:name</font>].present?
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@scope</font>&nbsp;= scope.where(<font color="#336633">'</font><font color="#a8ff60">name LIKE ?</font><font color="#336633">'</font>, <font color="#336633">&quot;</font><font color="#a8ff60">%</font><font color="#00a0a0">#{</font>params[<font color="#99cc99">:name</font>]<font color="#00a0a0">}</font><font color="#a8ff60">%</font><font color="#336633">&quot;</font>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#6699cc">end</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># I want to sort by the published_at column by default</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">sort</font>(default = <font color="#99cc99">:published_at</font>)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">super</font>(default)
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font></pre>

To use this filter, call it from the controller:

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Backend</font>::<font color="#ffffb6">PostsController</font>&nbsp;&lt; <font color="#ffffb6">ApplicationController</font>

&nbsp;&nbsp;respond_to <font color="#99cc99">:html</font>, <font color="#99cc99">:json</font>, <font color="#99cc99">:xml</font>

&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#ffd2a7">index</font>
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#c6c5fe">@posts</font>&nbsp;= <font color="#ffffb6">Filter</font>::<font color="#ffffb6">Posts</font>.new(params[<font color="#99cc99">:filter</font>]).all
&nbsp;&nbsp;&nbsp;&nbsp;respond_with <font color="#c6c5fe">@posts</font>
&nbsp;&nbsp;<font color="#96cbfe">end</font>

<font color="#96cbfe">end</font></pre>

As you can see, this places the logic of filtering in its proper place. It's not part of the model, since it's not part of initializing objects, or behavior of individual post objects. It's a separate service, doing something with something else.

These services are incredibly easy to make. Just think about the objects it's trying to handle. These are probably the arguments of your initializer. Store those methods with an instance variable. All methods you create do something with either these objects or call methods that do so.

Don't forget to run <a href="http://wiki.github.com/kevinrutherford/reek/">reek</a> on your code to see if you have any Low Cohesion or Feature Envy warnings. If you get any, than that method probably doesn't belong here, or you've got you're initial parameters wrong.

### Some bonus material

If you wish to simplify the interface even further, you can create a class method on the service to make it even easier (that's a service to create a service, so to speak).

<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#96cbfe">module</font>&nbsp;<font color="#ffffb6">Filter</font>
&nbsp;&nbsp;<font color="#96cbfe">class</font>&nbsp;<font color="#ffffb6">Base</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">def</font>&nbsp;<font color="#99cc99">self</font>.<font color="#ffd2a7">all</font>(*args)
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;new(*args).all
&nbsp;&nbsp;&nbsp;&nbsp;<font color="#96cbfe">end</font>

&nbsp;&nbsp;&nbsp;&nbsp;<font color="#7c7c7c"># ... rest of the base class ...</font>

&nbsp;&nbsp;<font color="#96cbfe">end</font>
<font color="#96cbfe">end</font></pre>

This reduces the connascence needed to use the service. Not really needed here, but it's a nice way of cleaning up your interface.

You might ask where do I put this into my Rails application. I make a folder <tt>app/services</tt> and (because I use RSpec) a folder named <tt>spec/services</tt>. If you use autotest, you need to tell it to pick up changes in these directories. You'll need to add the file <tt>.autotest</tt> to your application root folder, containing this bit of code to do the mapping:


<pre style="background: #000000; color: #f6f3e8; font-family: Monaco, monospace" class="ir_black"><font color="#ffffb6">Autotest</font>.add_hook <font color="#99cc99">:initialize</font>&nbsp;<font color="#6699cc">do</font>&nbsp;|<font color="#c6c5fe">at</font>|
&nbsp;&nbsp;at.add_mapping(<font color="#ff8000">%r%</font><font color="#e18964">^</font><font color="#b18a3d">spec/</font><font color="#e18964">(</font><font color="#e18964">.</font><font color="#e18964">*</font><font color="#e18964">)</font><font color="#b18a3d">_spec</font><font color="#e18964">\.</font><font color="#b18a3d">rb</font><font color="#e18964">$</font><font color="#ff8000">%</font>) { |<font color="#c6c5fe">filename</font>, <font color="#c6c5fe">_</font>|&nbsp;filename }
&nbsp;&nbsp;at.add_mapping(<font color="#ff8000">%r%</font><font color="#e18964">^</font><font color="#b18a3d">app/</font><font color="#e18964">(</font><font color="#e18964">.</font><font color="#e18964">*</font><font color="#e18964">)</font><font color="#e18964">\.</font><font color="#b18a3d">rb</font><font color="#e18964">$</font><font color="#ff8000">%</font>) { |<font color="#c6c5fe">_</font>, <font color="#c6c5fe">m</font>|&nbsp;[<font color="#336633">&quot;</font><font color="#a8ff60">spec/</font><font color="#00a0a0">#{</font>m[<font color="#ff73fd">1</font>]<font color="#00a0a0">}</font><font color="#a8ff60">_spec.rb</font><font color="#336633">&quot;</font>]&nbsp;}
<font color="#6699cc">end</font></pre>
