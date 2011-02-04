Just a quickie. We all know that Rails adds asset ids to images, javascript include tags and stylesheet link tags. This is to help the browser in caching assets properly. The generated code looks something like this:

<pre>
&lt;img src="rails.png?20849923" alt="Rails" />
</pre>

If I wonder if a website was made in Rails, I always look at the HTML. This is a good indicator.

Sometimes you don't want this behavior. It can get in the way of <tt>wget</tt>, which saves the file including everything after the question mark. But it's not that straightforward to turn this off. At least, I couldn't find it. There is not much information available on this subject and I had to dive into the Rails source code to solve it.

The easiest way I found was to override a helper method:

<pre lang="rails">
module ApplicationHelper
  def rewrite_asset_path(source)
    source
  end
end
</pre>

Please correct me if there is a simpler way!