Well then: **happy holidays!** This x-mas, there have been a few nice Ruby presents, like
the [merging of Rails with Merb](http://rubyonrails.org/merb) and Github [has a shiny new
feature](http://github.com/blog/277-pages-generator) for creating project sites.

I too will present you a Ruby x-mas present. It's a nice, but useless present, not totally out of
line with the usual x-mas presents.

It is a gem called [**not**](http://iain.github.com/not). With not you can get rid of exclamation
marks and the not keyword, and putting it later on in the sentence, thus making it better English.

An example:

``` ruby
# for core Ruby methods:
@foo.not.nil?
# or any custom method:
@user.not.active?
@user.not.save!
```

If you want it, you can install it as a gem:

``` bash
sudo gem install not
```

or as a Rails plugin:

``` bash
./script/plugin install git://github.com/iain/not.git
```

I hope you'll like it! **Happy holidays!**

### Update

I moved the gem to [gemcutter](http://gemcutter.org). If you haven't tumbled yet, please do so, before installing my gem:

``` bash
gem install gemcutter
gem tumble
```
