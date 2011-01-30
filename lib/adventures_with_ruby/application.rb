module AdventuresWithRuby
  class Application < Sinatra::Base

    set :public, File.expand_path('../../../public', __FILE__)

    set :haml, :format => :html5, ugly: true

    get '/' do
      @archive = Archive.new
      haml :index
    end

    get '/:article' do
      @article = Archive.find(params[:article])
      pass unless @article.found?
      haml :post
    end

    not_found do
      haml :not_found
    end

  end
end
