Cal it tiny, I don't care. I've made a gem named [BasicNamedScopes](http://github.com/iain/basic_named_scopes).

### Basic Usage

I was fed up with writing:

``` ruby
Post.all(:conditions => { :published => true }, :select => :title, :include => :author)
```

So with BasicNamedScopes, you can now write:

Post.conditions(:published => true).select(:title).with(:author)

All named scopes are called the same, except for `include`, which is now called `with`, because `include` is a reserved method.

Reuse them by making class methods:

``` ruby
class Post < ActiveRecord::Base
  def self.published
    conditions(:published => true)
  end

  def self.visible
    conditions(:visible => true)
  end

  def self.index
    published.visible
  end
end
```


Also, the `all`-method is a named scope now, so you can chain after callling `all`, for greater flexibility.

``` ruby
Post.all.published
```

Arrays can be used as multple parameters too, sparing you some brackets.

``` ruby
Post.with(:author, :comments).conditions("name LIKE ?", query)
```

The `read_only` and `lock` scopes default to true, but can be adjusted.

``` ruby
Post.readonly         # => same as Post.all(:readonly => true)
Post.readonly(false)  # => same as Post.all(:readonly => false)
```

### Why?

NamedScopes are really handy and they should play a more central theme in ActiveRecord. While I heard that Rails 3 will support similar syntax, there is no reason to wait any longer.

I find defining named scopes very ugly, especially when dealing with parameters. Just compare the amount of curly braces!

``` ruby
# Using normal named scope:
named_scope :name_like, lambda { |query| { :conditions => ["name LIKE ?", query] } }

# Using BasicNamedScopes
def self.name_like(query)
  conditions("name LIKE ?", query)
end
```


Also, regular named scopes don't support using other named scopes at all!

I found myself implementing these named scopes (mostly conditions, but others too) so often, that a little gem like this would be the obvious choice. Use it if a gem like [searchlogic](http://github.com/binarylogic/searchlogic) is overkill for your needs.

### Installing

The gem is called "basic_named_scopes". You know how to install it.

``` bash
gem install basic_named_scopes
```

Use it in Rails:

``` ruby
config.gem "basic_named_scopes"
```


### Update

The syntax is fully compatible with ActiveRecord 3, and if you're using ActiveRecord 3, you don't need to use this gem.
