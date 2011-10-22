If you're testing arrays a lot, like ActiveRecord's (named) scopes, you should know the following RSpec matcher: `=~`. It doesn't care about sorting and it gives you all the output you need when the spec fails. Here is an example:

``` ruby
describe "array matching" do

  it "should pass" do
    [ 1, 2, 3 ].should =~ [ 2, 3, 1 ]
  end

  it "should fail" do
    [ 1, 2, 3 ].should =~ [ 4, 2, 3 ]
  end

end
```


<figure class="ir_black"><img src="/rspec-array-matcher-result.png" alt="" title="rspec array matcher result" width="392" height="229"></figure>

Note: There is no inverse (should_not) version of this matcher.
