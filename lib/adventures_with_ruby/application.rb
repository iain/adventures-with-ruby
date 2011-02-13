# encoding: UTF-8

require File.expand_path('../helpers', __FILE__)

module AdventuresWithRuby
  class Application < Sinatra::Base
    include AdventuresWithRuby::Helpers

    set :public, File.expand_path('../../../public', __FILE__)

    set :haml, :format => :html5, ugly: true

    before do
      no_www!
      no_dates!
      @description = "Adventures with Ruby is a blog about developing with Ruby and Ruby on Rails, written by Iain Hecker."
    end

    get '/' do
      static!
      @intro = :index_intro
      haml :index
    end

    get '/articles.xml' do
      static! archive.last.published_at.to_s
      builder :rss
    end

    get '/articles' do
      static!
      @title = "All articles on Adventures with Ruby"
      @intro = :archive_intro
      haml :archive
    end

    get '/:article' do
      static!
      @article = Archive.find(params[:article])
      pass unless @article.found?
      @title       = "#{@article.title} - Adventures with Ruby"
      @description = @article.summary
      @intro       = :article_intro
      haml :article
    end

    not_found do
      static! "NOTFOUND"
      @intro = :not_found_intro
      haml :not_found
    end

  end
end
