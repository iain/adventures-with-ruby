If you find yourself needing a backend interface, you can either get an admin plugin of the shelf, like
[RailsAdmin](https://github.com/sferik/rails_admin) or [ActiveAdmin](http://activeadmin.info/), or
build your own. The of-the-shelf options provide a lot of functionality and are really worth a look.

You can also build your own backend. Building your own gives you maximum freedom. It requires a bit
more work, but it might be preferrable, especially if your customer also needs to work with it.

There are some awesome tools out there to help you build your own backend. I'll show you how I would
go about making such a backend. I'm using Rails 3.1 (the rc5 at this moment) on Ruby 1.9.2. I might
gloss over some details here and there, so use your own expertise to fill in some gaps.

The entire backend is available on [Github](https://github.com/iain/simple-backend-example). I have
also published the end result on [Heroku](http://simple-backend-example.heroku.com/backend) You can
log in with username "frodo" and the password "thering".

## A new application controller

A backend can be seen as a different application inside your regular application. That's why I start
out with a fresh application controller, just for the backend, from which every other controller can
inherit.

``` bash
rails generate controller backend/application
```

Because I don't want to be bothered by anything from the normal application controller, I choose to
inherit straight from `ActionController::Base`:

``` ruby
class Backend::ApplicationController < ActionController::Base
  protect_from_forgery
end
```


All routes should be in the backend too. This is extremely simple. Just wrap your normal routes
inside a `namespace` block:

``` ruby
SimpleBackendExample::Application.routes.draw do

  root to: "home#index"
  # other routes go here

  namespace :backend do
    root to: "products#index"
    resources :products
    resources :widgets
  end

end
```


Now it's time to implement these resources.

## Resources

Usually, you'll need a lot of CRUD resources inside your backend. I prefer to use the
[inherited_resources](https://github.com/josevalim/inherited_resources) gem.

First, make sure you install it, by adding it to your `Gemfile` and running the `bundle` command:

``` ruby
gem 'inherited_resources'
```

Next, I prefer to make a base class for all resource controllers too. This is the ideal place for
configuring Inherited Resources. Every CRUD controller can inherit from this one, while other
controllers can inherit from `Backend::ApplicationController`.

``` bash
rails generate controller backend/resource
```

Normally `inherited_resources` advices you to inherit from `InheritedResources::Base`. In turn,
`InheritedResources::Base` inherits from your own `ApplicationController`. But here we want to
inherit from `Backend::ApplicationController`. Luckily, we can do that:

``` ruby
class Backend::ResourceController < Backend::ApplicationController
  inherit_resources
  respond_to :html
end
```


Now, if we want to create a CRUD controller, we can do that by inheriting from
`Backend::ResourceController`.

``` bash
rails generate controller backend/products
```

The controller code is now really simple:

``` ruby
class Backend::ProductsController < Backend::ResourceController
end
```


## View inheritence

You're now free to make the views for every controller. This can be really boring, so it's a good
thing that Rails 3.1 ships with a feature called 'view inheritence'. This means that if a view does
not exist, it will go up the inheritence tree to find a view to render.

This means that we can create some simple views for our `Backend::ResourceController` and every
resource controller can render those. Only if we want something different, we need to make a
specific view. This means though that our views need to be agnostic about the model they're
handling.

Inherited Resources provides a lot of helpers to make views agnostic of the model they are
rendering. In the index action you have access to `collection`, in the other actions you can
reference `resource`. There are also URL helpers like `resource_path` and `collection_path`.

But if we're agnostic of the model, we need to use inflection to see which fields we can render. We
can ask the `resource_class` to see what attributes are defined. This will include automatic fields
like `id`, `updated_at` and `created_at` too. But even without these fields, the list can become
a bit too long for index pages.

In fact, I've found that the list of columns to display on the index page is something you want to
customize just about every time. So let's build a simple view to be overriden in every controller. In
`app/views/backend/resource/index.html.haml`, I put the following:

``` haml
= render "index", attributes: attributes
```

And add to the `Backend::ResourceHelper`:

``` ruby
module Backend::ResourceHelper

  def attributes
    resource_class.attribute_names - %w(id created_at updated_at)
  end

end
```



This will render the index-partial with the first three attributes of the model. The
index-partial then looks like this:

``` haml
%table
  %thead
    %tr
      - attributes.each do |attr|
        %th= resource_class.human_attribute_name(attr)
      %th &nbsp;
  %tbody
    - collection.each do |resource|
      %tr[resource]
        - attributes.each do |attr|
          %td= resource.public_send(attr).to_s.truncate(20)
        %td
          = link_to 'show', resource_path(resource)
          |
          = link_to 'edit', edit_resource_path(resource)
          |
          = link_to 'destroy', resource_path(resource), method: :delete, confirm: "Are you sure?"
```



I can now easily override this per controller. If, for example, I wanted to only show the name
column for products, I could create `app/views/backend/products/index.html.haml` with only this
line:

``` haml
= render "index", attributes: %w(name)
```

The show action probably wants to list everything, so it'll be something like this:

``` haml
%dl
  - resource_class.attribute_names.each do |attr|
    %dt= resource_class.human_attribute_name(attr)
    %dd= resource.public_send(attr)
```

## Simple Form

My favorite gem for creating forms is [simple_form](https://github.com/plataformatec/simple_form).
It is really flexible. Install it, by adding it to your `Gemfile` and following the instructions in
simple_form's README.

Our form partial in `app/view/backend/resource/_form.html.haml` will look something like:

``` haml
= simple_form_for [ :backend, resource ] do |f|
  - attributes.each do |attr|
    = f.input attr
  = f.submit
```



And the new and edit pages will simply render this partial, and look similar to the index template:

``` haml
%h2 Edit #{resource_class.model_name.human}

= render "form", attributes: attributes
```


## Scopes & Pagination

For the index page, you'll need pagination too. My favorite choice is
[Kaminari](https://github.com/amatsuda/kaminari) in combination with
[has_scope](https://github.com/plataformatec/has_scope):

``` ruby
gem 'kaminari'
gem 'has_scope', git: 'git://github.com/plataformatec/has_scope.git'
```


I'm using the version of `has_scope` directly, because it has a fixed a deprecation error.

Next, implement it by adding this line to `Backend::ResourceController`:

``` ruby
has_scope :page, default: 1
```


And put it in your view as well:

``` haml
= paginate collection
```

Super easy! Don't forget to run the generators provided by kaminari to configure it further, if you want.

## Responders

To get flash messages, we'll need to create a responder. The responders gem has a generator for
this, which you should use. We'll need a small tweak to get it to work:

``` ruby
# app/controllers/backend/responder.rb
class Backend::Responder < ActionController::Responder

  include Responders::FlashResponder
  include Responders::HttpCacheResponder

  def initialize(*)
    super
    @flash_now = :on_failure
  end

end
```


I've renamed it to make it clearer that this is the responder for the backend only. For the reason
of the initializer, see this [pull request](https://github.com/plataformatec/responders/pull/26).

To get flash messages for validation errors, you need to customize the locale file that was
generated, to include alert messages for create and update:

``` yaml
en:
  flash:
    actions:
      create:
        notice: '%{resource_name} was successfully created.'
        alert: '%{resource_name} could not be created.'
      update:
        notice: '%{resource_name} was successfully updated.'
        alert: '%{resource_name} could not be updated.'
      destroy:
        notice: '%{resource_name} was successfully destroyed.'
        alert: '%{resource_name} could not be destroyed.'
```


Next, you'll need to add it to `Backend::ResourceController`, because Inherited Resources will
otherwise override it with its own responders.

``` ruby
# app/controllers/backend/resource_controller.rb
self.responder = Backend::Responder
```

By adding the `HttpCacheResponder`, the website speeds up quite a bit. It will set the appropriate
headers, like ETags, based on the resource you're viewing. This means that if you're viewing a page
for the second time, you don't have to render the view anymore and your Rails app only sends a `304
Not Modified` to your browser. If you're viewing my example on Heroku, you can see Varnish adding
another layer of caching on top of it, using those ETags. It makes your backend really snappy!

## Authentication

Our backend needs to be private, so we'll need some form of authentication. In most cases (more
than you'd think even) basic authentication will work. This can be easily done inside the
`Backend::ApplicationController`, by adding one simple line:

``` ruby
http_basic_authenticate_with name: "frodo", password: "thering"
```


If you're opting for a more complex system, with users and so on, I would go for
[Devise](https://github.com/plataformatec/devise). The powerful thing about Devise is that you can
really easily create a multiple types of users who have nothing with each other in common. They each
have their own tables and sign in pages.

You can configure Devise to use your own controllers instead of its own, so you can really separate
the admins from the rest of the system.

To generate administrators:

``` bash
rails generate devise admin
```

Then I prefer to place the views inside the backend namespace as well. This means that I need to
recreate the controllers that Devise provides. This sounds like a lot of work, but it also means
that I can really easily customize it. Rather than depending on the customization hooks that Devise
provides (they are really good), I can override certain methods inside the controller. Devise's code
is so nice, I can easily override just the functionality I like to make it work.

To do this, place the `devise_for` route inside your namespace:

``` ruby
namespace :backend do
  devise_for :admins, skip: :registrations
end
```

And create controllers like this:

``` ruby
class Backend::SessionsController < Devise::SessionsController
  layout "backend/sign_in"
end
```


As you can see, I can now easily define the backend layout inside
the controller, without having to revert to a more complex [hook
method](https://github.com/plataformatec/devise/wiki/How-To:-Create-custom-layouts). Remember
that, due to view inheritance, you don't need to install the views. The original views that Devise
provides are in the inheritence tree, so they will be rendered if you don't provide your own.

And don't forget to activate the authentication to every controller in the backend, by adding to
your `Backend::ApplicationController`:

``` ruby
before_filter :authenticate_admin!
```


Personally, I would try to avoid going with Devise and stick to basic authentication as long as
possible. That's also one of the main reasons I don't tend to go with the of the shelf admin
solutions. They require Devise. It adds a lot of overhead that I don't usually need. You might also
want to check out the [Railscast](http://railscasts.com/episodes/270-authentication-in-rails-3-1) on
creating your own authentication system.

## Styling

So, we now have a nice backend system in place. But it still looks ugly. Time
to add some style! Let's get something of-the-shelf to get going. I like
[web-app-theme](https://github.com/pilu/web-app-theme). This will make our backend look just like
RailsAdmin.

The easiest way to get a theme, I found, is to just clone web-app-theme somewhere and copy over the
files you need. Rails 3.1 has the asset pipeline, so this means we can have a nice spot to put them:
in the `vendor/assets` directory.

``` bash
mkdir -p vendor/assets/stylesheets/web-app-theme
cp ../web-app-theme/stylesheets/base.css vendor/assets/stylesheets/web-app-theme/
cp ../web-app-theme/stylesheets/themes/default/style.css vendor/assets/stylesheets/web-app-theme
cp -r ../web-app-theme/stylesheets/themes/default/images vendor/assets
cp -r ../web-app-theme/stylesheets/themes/default/fonts public
```

You need to change styles.css a bit to change the paths to images and any custom fonts. In Rails
3.1, assets aren't located in an `images` directory, but in `/assets`. Fonts are not served through
Rails, so those should go inside the `public` directory. A quick find and replace should do the
trick just fine.

Next up is the layout. You can install web-app-theme as a gem in your project and let
it generate the layout for you. This is not necessary. You can find a layout inside
`lib/generators/web_app_theme/theme/templates/layout_admin.html.erb`. Copy it to
`app/views/layouts/backend/application.html.erb`. Remember, view inheritance will automatically pick
it up for every controller in the backend. I'm a Haml user, so I converted it using `html2haml`:

``` bash
gem install hpricot ruby_parser
mkdir -p app/views/layouts/backend
html2haml ../web-app-theme/lib/web_app_theme/theme/layout_admin.html.erb > app/views/layouts/backend/application.html.haml
```

You have some cleaning up to do. Or just [grab the
one](https://github.com/iain/simple-backend-example/blob/master/app/views/layouts/backend/application.html.haml)
I've already made! Afterwards, look at the classes web-app-theme uses and apply it to
your views as well.

To include the stylesheets, I just include one inside the layout:

``` haml
= stylesheet_link_tag "backend"
```

In `app/assets/stylesheets/backend.css`, I use the awesome power of Sprockets to include the rest:

``` css
/*
 *= require web-app-theme/base
 *= require web-app-theme/style
 *= require_tree ./backend
 */
```


It also includes every css file I have inside the `app/assets/stylesheets/backend` directory, which
is where future customizations will go.

I also use the same structure for javascripts, creating the following
`app/assets/javascripts/backend.js`:

``` javascript
//= require jquery
//= require jquery_ujs
//= require_tree ./backend
```


This styling would give you enough to start your backend. There are a ton of customizations you can
do, but I'll leave that up to you.

## More namespacing

Because of the way namespacing works, you can customize your models for use in the backend. This
allows you to add methods for use in the backend only, without cluttering your classes in the rest
of the application.

``` ruby
# app/models/product.rb
class Product < ActiveRecord::Base
  has_many :widgets
end

# app/models/backend/product.rb
class Backend::Product < ::Product

  def deactivate_all_widgets
    widgets.each(&:deactivate)
  end

end
```


Because Inherited Resources is in the Backend namespace, it will use this class instead of the normal
one.

You can also make use of lexical scoping to implicitly reference the namespaced classes. This is
quite subtle, so it's a bit error-prone.

In the following example, `@product` will be an instance of `Backend::Product`:

``` ruby
module Backend
  class ProductsController
    def new
      @product = Product.new
    end
  end
end
```


In the next example, `@product` will be an instance of `::Product`, because only the `class` and
`module` keywords will create the scope for you. You are scoped inside
`Backend::ProductsController`, but not really inside `Backend`.

``` ruby
class Backend::ProductsController
  def new
    @product = Product.new
  end
end
```



Also, you don't need to explicitly tell the form that its resource needs to be scoped to the
backend. There are a lot of tiny nuances that change when you go this route. So beware. Ruby's
namespacing is powerful, but combined with Rails' naming conventions it can also be a bit confusing
at times.

## Conclusion

Making your own backend is really easy. Sure, there are out of the box gems that do all this for
you and more. But if you want more control, yet still get some of the productivity, Rails 3.1 has all the
tools to make it work. All the gems I've used fit nicely together. Sure, most of them are
made by [José Valim](http://twitter.com/josevalim), or by his company
[Plataforma](http://www.plataformatec.com.br/en/), but it shows how extensible the Rails platform really
is.

Whether to choose for a custom solution or something more automatic is something you should decide
on a per-project basis. If you're building it for non-technical customers, doing it yourself might
be the better solution. But products like RailsAdmin give so much nice features, you'd better make
sure.
