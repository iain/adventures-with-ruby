Testing ActiveRecord doesn't have to be slow. With some clever loading you can
require only the parts that you need and it isn't even that difficult.

Another reason might be that you're using ActiveRecord without Rails. This
might be in another framework like Sinatra, or in a gem. Without Rails you
might be lost a little on how to set up ActiveRecord.

## Preparation

First, install the gems you'll need. This should be enough:

```
gem install activerecord rspec sqlite3
```

I'm using a really simple spec to get up and running. I'm even defining the
model inside the spec itself, just because it's easier to get started:

``` ruby
# spec/widget_spec.rb

class Widget < ActiveRecord::Base
  validates_presence_of :name
end

describe Widget do

  it "requires a name" do
    subject.name = ""
    subject.should have(1).error_on(:name)
    subject.name = "Foo"
    subject.should have(:no).errors_on(:name)
  end

end
```

## Loading ActiveRecord

Run this spec on its own, simply by running:

```
rspec spec/widget_spec.rb
```

You'll see that it doesn't even know ActiveRecord yet.

Let's create a support file for specs that need ActiveRecord. I put this in
`spec/support/active_record.rb`.

For now, this file will just require ActiveRecord for us:

``` ruby
# Create the file spec/support/active_record.rb:

require 'active_record'
```

We need ActiveRecord before we define our model, so require the support file at
the very top of your spec:

``` ruby
# Prepend to spec/widget_spec.rb:

require 'support/active_record'
```

RSpec automatically adds the `lib` and `spec` directory to the load paths, so
these files can be required easily.

## Connecting with the database

When we run the spec now, it should tell us that ActiveRecord has no connection
with the database. I'm going for a SQLite database in memory, so let's define
the connection in the support file.

``` ruby
# Append to spec/support/active_record.rb:

ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
```

When we run it now, it will tell us that we don't have a table yet.

## Run migrations

If you have migrations, you can run them with just one simple line:

``` ruby
# Append to spec/support/active_record.rb:

ActiveRecord::Migrator.up "db/migrate"
```

You can also just create the migration inline, which is probably even simpler:

``` ruby
# Append to spec/support/active_record.rb:

ActiveRecord::Migration.create_table :widgets do |t|
  t.string :name
  t.timestamps
end
```

If you have a `schema.rb` file, you can simply load it:

``` ruby
# Append to spec/support/active_record.rb:

load "path/to/db/schema.rb"
```

## Getting some RSpec helpers

When we run it now, we'll see the familiar output of the migrations. The next
error we get is an undefined method `error_on`.

If your project already depends on `rspec-rails`, you can simply require the file:

``` ruby
# Append to spec/support/active_record.rb:
require 'rspec/rails/extensions/active_record/base'
```

If you're not in a Rails project (but in a Gem or Engine), you might not want
to have rspec-rails as a dependency, because it adds a lot of extra
dependencies. You can just define the `error_on` method yourself, by
copy-pasting it:

``` ruby
# Append to spec/support/active_record.rb:

module ActiveModel::Validations
  # Extension to enhance `should have` on AR Model instances.  Calls
  # model.valid? in order to prepare the object's errors object.
  #
  # You can also use this to specify the content of the error messages.
  #
  # @example
  #
  #     model.should have(:no).errors_on(:attribute)
  #     model.should have(1).error_on(:attribute)
  #     model.should have(n).errors_on(:attribute)
  #
  #     model.errors_on(:attribute).should include("can't be blank")
  def errors_on(attribute)
    self.valid?
    [self.errors[attribute]].flatten.compact
  end
  alias :error_on :errors_on
end
```

This should be enough to get your spec running! And look how fast it is!
Clearly, loading ActiveRecord isn't what makes Rails startup time slow.

## Transactions

The last part you'll want is to run your specs in transactions, so that one
spec doesn't influence the others. To do this, we'll make a simple around
filter:

``` ruby
# Append to spec/support/active_record.rb:

RSpec.configure do |config|
  config.around do |example|
    ActiveRecord::Base.transaction do
      example.run
      raise ActiveRecord::Rollback
    end
  end
end
```

The `ActiveRecord::Rollback` exception will be caught by the transaction block
and roll back all the database changes after each spec.

## Profit!!!

Now, you might want to clean it up a little more, but this should be enough to
getting you started testing your ActiveRecord classes in (relative) isolation.
And the cool thing is, running these specs hardly takes any time!

If you have any tips, please share them in the comment-section below.

If you want to know more about how ActiveRecord works, I can recommended [this
good series of posts](http://www.tamingthemindmonkey.com/) by [Robin
Roestenburg](http://twitter.com/robinroest). In the course of several blog
posts he dives into the inner workings of ActiveRecord, even refactoring parts
of it.

Next up: Testing controllers in isolation. Stay tuned!
