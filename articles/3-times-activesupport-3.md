Rails 3 is coming. All the big changes are spoken of elsewhere, so I'm going to mention some small changes. Here are 3 random new methods added to ActiveSupport:

### presence

First up is `Object#presence` which is a shortcut for `Object#present? && Object`. It is a bit of a sanitizer. Empty strings and other blank values will return `nil` and any other value will return itself. Use this one and your code might be a tad cleaner.

``` ruby
"".presence # => nil
"foo".presence #=> "foo"

# without presence:
if params[:foo].present? && (foo = params[:foo])
  # ..
end

# with presence:
if foo = params[:foo].presence
  # ...
end

# The example Rails gives:
state   = params[:state]   if params[:state].present?
country = params[:country] if params[:country].present?
region  = state || country || 'US'
# ...becomes:
region = params[:state].presence || params[:country].presence || 'US'
```

I like this way of cleaning up you're code. I guess it's Rubyesque to feel the need to tidy and shorten your code like this.

### uniq_by

Another funny one is `Array.uniq_by` (and it sister-with-a-bang-method). It works as select, but returns only the first element from the array that complies with the block you gave it. Here are some examples to illustrate that:

``` ruby
[ 1, 2, 3, 4 ].uniq_by(&:odd?) # => [ 1, 2 ]

posts = %W"foo bar foo".map.with_index do |title, i|
  Post.create(:title => title, :index => i)
end
posts.uniq_by(&:title)
# => [ Post("foo", 0), Post("bar", 1) ] ( and not Post("foo", 2) )

some_array.uniq_by(&:object_id) # same as some_array.uniq
```

### exclude?

And the final one for today is `exclude?` which is the opposite of `include?`. Nobody likes the exclamation mark before predicate methods.

``` ruby
# yuck:
!some_array.include?(some_value)
# better:
some_array.exclude?(some_value)
```

And it also works on strings:

``` ruby
# even more yuck:
!"The quick fox".include?("quick") # => false
# better:
"The quick fox".exclude?("quick") # => false
```

The full release notes of Rails 3 can be [read here](http://guides.rails.info/3_0_release_notes.html).
