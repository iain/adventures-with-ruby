# encoding: UTF-8

module AdventuresWithRuby
  class Application < Sinatra::Base

    set :public, File.expand_path('../../../public', __FILE__)

    set :haml, :format => :html5, ugly: true

    before do
      # no www
      redirect "#{request.scheme}://#{$1}", 301 if request.url =~ %r|^#{request.scheme}://www\.(.*)$|
      # no /1945/5/the-war-has-ended posts
      redirect "#{request.scheme}://#{request.host}/#{$1}", 301 if request.url =~ %r|/20\d\d/\d{1,2}/(.*)$|


      @description = "Adventures with Ruby is a blog about developing with Ruby and Ruby on Rails, written by Iain Hecker."

      # every page is chachable
      unless ENV['TEST']
        response['Cache-Control'] = 'public, max-age=3600'
        etag request.path.bytes.to_a.join
      end
    end

    get '/' do
      puts "Accessed index page at #{Time.now}"
      @intro = :index_intro
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
      @intro = :archive_intro
      @archive = Archive.new
      haml :archive
    end

    get '/:article' do
      @article = Archive.find(params[:article])
      pass unless @article.found?
      puts "Accessed #{@article.url} page at #{Time.now}"
      @title = "#{@article.title} - Adventures with Ruby"
      @description = @article.summary
      @intro = :article_intro
      haml :article
    end

    not_found do
      @intro = :not_found_intro
      haml :not_found
    end

  end
end
