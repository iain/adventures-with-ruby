# encoding: UTF-8
require 'cgi'

module AdventuresWithRuby
  class Application < Sinatra::Base

    set :public, File.expand_path('../../../public', __FILE__)

    set :haml, :format => :html5, ugly: true

    before do
      # no www
      redirect "#{request.scheme}://#{$1}", 301 if request.url =~ %r|^#{request.scheme}://www\.(.*)$|
      # no /1945/5/the-war-has-ended posts
      redirect "#{request.scheme}://#{request.host}/#{$1}", 301 if request.url =~ %r|/20\d\d/\d{1,2}/(.*)$|
      # every page is chachable
      response['Cache-Control'] = 'public, max-age=3600'
      etag request.path.bytes.to_a.join
    end

    get '/' do
      puts "Accessed index page at #{Time.now}"
      @archive = Archive.new
      haml :index
    end

    get '/articles.xml' do
      puts "Accessed rss page at #{Time.now}"
      @archive = Archive.new
      builder :rss
    end

    get '/articles' do
      puts "Accessed all articles page at #{Time.now}"
      @title   = "All articles on Adventures with Ruby"
      @archive = Archive.new
      haml :archive
    end

    get '/:article' do
      @article = Archive.find(params[:article])
      pass unless @article.found?
      puts "Accessed #{@article.url} page at #{Time.now}"
      @title = "#{@article.title} - Adventures with Ruby"
      @description = @article.summary
      haml :article
    end

    not_found do
      haml :not_found
    end

  end
end
