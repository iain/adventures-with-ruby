Well then: <strong>happy holidays!</strong> This x-mas, there have been a few nice Ruby presents, like the <a href="http://rubyonrails.org/merb" target="_blank">merging of Rails with Merb</a> and Github <a href="http://github.com/blog/277-pages-generator" target="_blank">has a shiny new feature</a> for creating project sites.

I too will present you a Ruby x-mas present. It's a nice, but useless present, not totally out of line with the usual x-mas presents.

It is a gem called <a href="http://iain.github.com/not" target="_blank"><strong>not</strong></a>. With not you can get rid of exclamation marks and the not keyword, and putting it later on in the sentence, thus making it better English.

An example:

[sourcecode language='ruby']
# for core Ruby methods:
@foo.not.nil?
# or any custom method:
@user.not.active?
@user.not.save!
[/sourcecode]

If you want it, you can install it as a gem:

[sourcecode language='bash']sudo gem install not[/sourcecode]

or as a Rails plugin:

[sourcecode language='bash']./script/plugin install git://github.com/iain/not.git[/sourcecode]

I hope you'll like it! <a href="http://iain.nl/xmas/"><strong>Happy holidays!</strong></a>

<h2>Update</h2>
I moved the gem to <a href="http://gemcutter.org">gemcutter</a>. If you haven't tumbled yet, please do so, before installing my gem:

[sourcecode language='bash']
gem install gemcutter
gem tumble
[/sourcecode] 