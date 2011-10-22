Here are some improvements for [Fancy Named Routes - Part I](/fancy-named-routes). In this part we will be adding a more thorough solution for the html escaping in everywhere.  I noticed this was absolutely important, when I tried to view an escaped url in a production environment with Apache with mod_proxy and mongrel_cluster. Apache doesn't like '%2F' in the title, and doesn't forward the request to mongrel, so it returns a nice 404.

To rid yourself of the problem once and for all, add this to your ApplicationController:

    def url_for(options)
      url = super(options)
      url.gsub!("%2F","/") if has_nice_url?(url)
      url
    end

    def has_nice_url?(link)
      rs = ::ActionController::Routing::Routes
      segments = rs.recognize_path link
      rs.named_routes.routes.each do |key,value|
        return true if
          value.defaults.has_value?(segments[:controller]) and
          value.defaults.has_value?(segments[:action]) and
          value.defaults.include?(:nice_url)
      end
    rescue ::ActionController::RoutingError
      logger.debug{"RoutingError has occured"}
    end

Now there is no need for overloading link_to or redirected_to. Remember, you'll need this in your config/routes.rb, to make it all work:

    map.show_article 'article/:id/*nice_url', :controller => 'articles', :action => 'show', :nice_url => nil

And in your model, you have to add:

    def to_param
      self.id.to_s+'/'+self.title.gsub(/\W+/,'-').downcase+'.html'
    end

Now you can make awesome links like this:

    link_to h(@article.title), show_article_url(@article)
    redirect_to show_article_url(@article)
