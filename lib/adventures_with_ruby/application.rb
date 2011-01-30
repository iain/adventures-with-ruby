# encoding: UTF-8
require 'cgi'

module AdventuresWithRuby
  class Application < Sinatra::Base

    set :public, File.expand_path('../../../public', __FILE__)

    set :haml, :format => :html5, ugly: true

    before do
      redirect "#{request.scheme}://#{$1}", 301 if request.url =~ %r|^#{request.scheme}://www\.(.*)$|
    end

    get '/' do
      @archive = Archive.new
      haml :index
    end

    get '/rss.xml' do
      @archive = Archive.new
      builder :rss
    end

    get '/:article' do
      @article = Archive.find(params[:article])
      pass unless @article.found?
      haml :article
    end

    not_found do
      haml :not_found
    end

  end
end
