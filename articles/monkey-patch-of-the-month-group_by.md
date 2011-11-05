A while back, I talked about [new additions to ActiveSupport](/3-times-activesupport-3). And
now, I have a confession to make: I like monkey patches! At least, as long as they're short and
self-explanatory.

I got a few of them lying around, so I am going to post one every month. I also welcome your
favorite monkey patch, which you can [email me](mailto:monkey@iain.nl).

So, the first one: `group_by`. This method groups arrays of objects by the result
of the block provided and puts the result into a hash.

``` ruby
class Array
  # Turns an array into a hash, using the results of the block as keys for the
  # hash.
  #
  #   [1, 2, 3, 4].group_by(&:odd?)
  #   # => {true=>[1, 3], false=>[2, 4]}
  #
  #   ["One", "Two", "three"].group_by {|i| i[0,1].upcase }
  #   # => {"T"=>["Two", "three"], "O"=>["One"]}
  def group_by
    hash = Hash.new { |hash, key| hash[key] = [] }
    each { |item| hash[yield(item)] << item }
    hash
  end
end
```

No piece of code is complete without tests, so this is it:

``` ruby
class ArrayExtGroupingTests < Test::Unit::TestCase

  def test_group_by
    assert_equal {true=>[1, 3], false=>[2, 4]}, [1, 2, 3, 4].group_by(&:odd?)
    assert_equal {"T"=>["Two", "three"], "O"=>["One"]}, ["One", "Two", "three"].group_by {|i| i[0,1].upcase }
  end

end
```

### Update

Silly me, this one is [already in Ruby itself](http://apidock.com/ruby/Enumerable/group_by). Anyway,
this is how it works under the cover...
