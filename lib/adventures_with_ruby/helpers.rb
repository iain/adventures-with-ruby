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
        redirect "#{request.scheme}://#{$1}", 301
      end
    end

    def no_dates!
      if request.url =~ %r|/20\d\d/\d{1,2}/(.*)$|
        redirect "#{request.scheme}://#{request.host}/#{$1}", 301
      end
    end

    def static!(etag = nil)
      unless request.host.include?("localhost")
        response['Cache-Control'] = 'public, max-age=3600'
        self.etag(etag || request.path.bytes.to_a.join)
      end
    end

  end
end
