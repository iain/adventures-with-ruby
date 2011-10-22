require 'sinatra'
require 'haml'
require 'builder'
require 'yaml'
require 'cgi'

require 'index'
require 'index_reader'
require 'article_not_found'
require 'article'
require 'oldness'
require 'contents_storage'
require 'disqus'
require 'contents'
require 'archive'
require 'helpers'

include Helpers

set :haml, :format => :html5, :ugly => true
set :root, File.expand_path('../..', __FILE__)

before do
  no_www!
  no_dates!
  no_trailing_slashes!
  @description = "Adventures with Ruby is a blog about developing with Ruby and Ruby on Rails, written by Iain Hecker."
end

get '/' do
  static
  @intro = :index_intro
  haml :index
end

get '/feed' do
  static archive.last.published_at.to_s
  builder :rss
end

get '/articles' do
  static
  @title = "All articles on Adventures with Ruby"
  @intro = :archive_intro
  haml :archive
end

get '/:article' do
  @article = Index.find(params[:article])
  if @article.found?
    static
    @title       = "#{@article.title} - Adventures with Ruby"
    @description = @article.summary
    @intro       = :article_intro
    haml :article
  else
    pass
  end
end

not_found do
  static "NOTFOUND"
  @intro = :not_found_intro
  haml :not_found
end
