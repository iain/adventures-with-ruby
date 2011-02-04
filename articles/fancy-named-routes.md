I know <a href="http://tweakers.net" title="tweakers.net" target="_blank">tweakers.net</a> has it, I liked it, and I wanted it for myself. The uris of news items are like this: <tt>http://core.tweakers.net/nieuws/50373/intel-stoot-ontwikkeling-netwerkprocessors-af.html</tt>

First you get the id, than you get a nice version of the title ending with .html. This is a nice way of making links, scoring high for a googlebot and is incredibly easy to read.

I first tried to use only the title as an identifier. Now normally there would be a problem with having titles in your uri. First of all you might want to have special characters in your title. Rails automatically converts them back into the characters they are when evaluating the routes, so it would result in this problem: <em>/news/my%2Ftitle.html</em> would evaluate to <em>/news/my/title.html</em>, which the Rails Router doesn't understand.<!--more-->

Besides, it doesn't look good. But when changing the title to <em>my-title.html</em>, just for output, there is no good way of getting it back to the original title. Even more problematic is <em>my/title</em> and <em>my-title</em> would lead to the same page. I concluded that you'll definitely need an id in your uri. But how would I have the title in it then?

The solution is a nice named route, like this one:

<pre lang="rails">map.news 'news/:id/*nice_url', :controller => 'news', :action => 'show'</pre>
Now to get the title to appear automatically, so you don't have to code it every time you make a link. Go to the model and add this method:

<pre lang="rails">
def to_param
  self.id.to_s+'/'+self.title.gsub(/\W/, '-').squeeze('-').downcase+'.html'
end</pre>
Now every time you use news_url(@news) it adds the title nicely formatted. One downside though: Because it is a parameter Ruby converts it to %2F. As it should, I might add. But in this case we don't want it, it looks silly. But it works. Fixing this is a bit tricky. You must overload the link_to function. I've done it like this:
<pre lang="rails">
def link_to(text, link, *options)
  super(text, convert_nice_url(link), *options)
end

private

  def bare_path(txt)
    txt.sub(/^\/*/, '/').sub(index_url,'')
  end

  def convert_nice_url(link)
    link = url_for(link) unless link.is_a?(String)
    rs = ::ActionController::Routing::Routes
    segments = rs.recognize_path(bare_path(link))
    has_nice_url = false
    rs.named_routes.routes.each do |key,value|
      has_nice_url = true if
        value.defaults.has_value?(segments[:controller]) and
        value.defaults.has_value?(segments[:action]) and
        value.defaults.include?(:nice_url)
    end
    link.gsub!("%2F","/") if has_nice_url
    return link
  rescue ::ActionController::RoutingError
    return link
  end</pre>
It looks if your route has the parameter <em>*nice_url</em> and in that case it replaces <em>%2F</em> with genuine forward slashes. You might want to do this for <em>link_to_remote</em> and <em>redirect_to</em> as well.

<strong>Update:</strong> In routes.rb, don't forget to add a named route called index, pointing to '', as a default route. This script needs that. Furthermore, you need to make the default of the parameter nice_url nil. This is the final version of routes.rb:
<pre lang="rails">
map.index '', :controller => 'news', :action=>'index'
map.news 'news/:id/*nice_url', :controller => 'news', :action => 'show', :nice_url => nil</pre>
<strong>Update 2:</strong> I will be following up on this item, to properly implement this. Come back again later!