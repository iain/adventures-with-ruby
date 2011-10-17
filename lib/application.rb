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

set :haml, :format => :html5, :ugly => true
set :root, File.expand_path('../..', __FILE__)

# TODO stubs to make the old views work
def articles(*)
end

# TODO stubs to make the old views work
def archive
  []
end

def article
  @article
end

def partial(name, *args)
  haml :"_#{name}", *args
end

get '/' do
  haml :index
end

get '/feed' do
  builder :rss
end

get '/articles' do
  haml :archive
end

get '/:article' do
  @article = Index.find(params[:article])
  if @article.found?
    haml :article
  else
    pass
  end
end

not_found do
  static!
  @intro = :not_found_intro
  haml :not_found
end
