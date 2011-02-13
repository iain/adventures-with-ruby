module AdventuresWithRuby
  module Helpers

    def partial(name, locals = {}, options = {})
      haml :"_#{name}", options, locals
    end

    def articles(name, articles)
      html = ""
      articles.each do |article|
        html << partial(:article, article: article, content: partial(name, article: article))
      end
      html
    end

    def archive
      @archive ||= Archive.instance
    end

    def no_www!
      if request.url =~ %r|^#{request.scheme}://www\.(.*)$|
        redirect "#{scheme}#{$1}", redirect_code
      end
    end

    def no_dates!
      if request.url =~ %r|/20\d\d/\d{1,2}/(.*)$|
        redirect "#{domain}/#{$1}", redirect_code
      end
    end

    def static!(etag = nil)
      unless local?
        response['Cache-Control'] = 'public, max-age=3600'
        self.etag(etag || request.path.bytes.to_a.join)
      end
    end

    def no_trailing_slashes!
      if request.path =~ %r|(^/.+)/$|
        redirect "#{domain}#{$1}", redirect_code
      end
    end

    def local?
      request.host.include?("localhost")
    end

    def scheme
      "#{request.scheme}://"
    end

    def host
      "#{request.host}#{port}"
    end

    def domain
      "#{scheme}#{host}"
    end

    def port
      request.port.to_i == 80 ? "" : ":#{request.port}"
    end

    def redirect_code
      local? ? 302 : 301
    end

  end
end
