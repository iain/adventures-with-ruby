Did you know you can create as many groups in Bundler as you like? You can and
I think you should! Let me show you some ways I use groups to clean up my
Gemfile.

## Why groups?

**Speed:** Requiring gems can get slow, even more so when you have a lot of
them. Groups help you require the gems only when they are needed.

This is especially true if you use Ruby 1.9.2. In this version of Ruby, the
`require` statement can get very slow. Since the number of gems inside a
project can get rather large. Loading only the gems that are needed can improve
Rails boot time immensely.

**Safety:** Some gems provide functionality that you don't want to enable in
certain cases.  Take webmock, for instance. This handy gem blocks all outgoing
network traffic inside your application. Very handy for testing purposes, but
not in production!


**Clearity:** The group name can act as documentation. If you ever wonder what
a gem does and where it is used inside your application, a group can tell you a
lot.

## The Basics

You probably already know the basics of groups in Bundler. Rails already uses
groups out of the box. If you have a group named after the Rails environment,
it will get loaded.

If you have gems that are used in the application itself, your best bet is to
put them outside of any group. I'm talking about gems like Rails itself,
devise, will_paginate, and so on.

Gems without a specified group are placed in the `:default` group and will be
loaded in every Rails environment.

This is your safest choice. When in doubt in which group to place a gem, don't
use a group at all.

## Adding custom groups

You can easily add other groups. For example, Rails 3.1 and up have gems in the
`:assets` group. This line from `config/application.rb` instructs Bundler to
only require the assets in development and test environments.

``` ruby
Bundler.require(*Rails.groups(:assets => %w(development test)))
```

You can add your own groups and let Bundler require them automatically.

Here is an example:

``` ruby
group :security do
  gem 'devise'
  gem 'cancan'
end

group :monitoring do
  gem 'newrelic_rpm'
  gem 'airbrake'
end
```

So, we want security to always be there, but monitoring only in production.
Then your configuration inside `config/application.rb` should read:

``` ruby
groups = {
  assets:     %w(development test),
  monitoring: %w(production)
}
Bundler.require(:security, *Rails.groups(groups))
```

You can group together gems per type of gem, like `:assets`, or per part of the
application, like `:security`, or `:backend`. See what makes the most sense for
your application.

## Grouping related gems

When you use Cucumber, Spinach, or Turnip, you'll end up with a set of related
gems.  When you cram all of these into the test group, they'll end up loaded in
your RSpec tests too.

You could create a group for this:

``` ruby
group :cucumber do
  gem 'cucumber-rails'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
end
```

This group won't be loaded. If you want to require these gems inside your
Cucumber tests, add this line to `features/support/env.rb`:

``` ruby
Bundler.require(:cucumber)
```

You could do this for other groups of related gems too. For instance, you might
have a couple of scripts or rake tasks running periodically that use gems that
you don't use in the rest of your application. With groups you can require them
at the right moment.

## Other gems

There are also some gems that are only used from the command line. An example
might be thin, or capistrano. Here are some more examples:

``` ruby
group :capistrano do
  gem 'capistrano'
  gem 'capistrano-ext'
  gem 'capistrano_colors'
  gem 'capistrano_chef_solo'
end

group :test_tools do
  gem 'autotest'
  gem 'spork'
  gem 'spec_coverage', :platforms => :ruby_19
  gem 'fuubar'
  gem 'fuubar-cucumber'
end
```

There is no need to add `:require => false` to every gem, because it won't get
loaded anyway. These gems either provide a command line tool like `cap` or
`autotest`, or they will be required manually at a specific moment, only when
they are needed.

## Console Extensions

There are a number of gems that will spice up your IRB session, like
awesome_print, hirb and wirb. You can load them inside your `~/.irbrc` file,
but if they are not present inside your Gemfile, they won't be available
inside projects using Bundler.

A group can play a part in solving this problem.

``` ruby
group :console do
  gem 'wirb'
  gem 'hirb-unicode'
  gem 'awesome_print', :require => 'ap'
end
```

Now, to automatically load them in Rails, but only when opening the console,
open up `config/application.rb`.  At the top you'll find an if-statement
checking for Bundler. Inside this block, you can add this piece of code:

``` ruby
Class.new Rails::Railtie do
  console do |app|
    Bundler.require(:console)
    Wirb.start
    Hirb.enable
  end
end
```

This creates an anonymous Railtie in which you can specify what happens when
the console is started. Here you can require all your console extensions and
perform additional configuration.

Railties need to be loaded before you define your Rails application, or else
you're too late and the console block won't be executed.
