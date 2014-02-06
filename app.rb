require "sinatra"
require "sequel"
require "redcarpet"

require "./lib/all"

helpers do
  def protected!(&blk)
    if authorized?
      blk.call
    else
      headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
      halt 401, "Not authorized\n"
    end
  end

  def authorized?
    admin_credentials = if ENV["RACK_ENV"] == "production"
      [ENV["ADMIN_USERNAME"], ENV["ADMIN_PASSWORD"]]
    else
      ["admin", "admin"]
    end      
    
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == admin_credentials
  end
end

DB = Sequel.connect(ENV["DATABASE_URL"] || "sqlite://tangent.db")

get '/' do
  erb :home
end

get '/admin' do
  protected! do
    erb :admin, :layout => :admin_layout
  end
end

get '/admin/articles' do
  protected! do
    articles = ArticleService.new(DB).fetch_all
    erb :admin_articles, :locals => { :articles => articles }, :layout => :admin_layout
  end
end

get '/admin/articles/new' do
  protected! do
    erb :admin_articles_new, :layout => :admin_layout
  end
end

get '/admin/articles/:id' do
  protected! do
    article = ArticleService.new(DB).fetch(params[:id])
    
    markdown_renderer = ::Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    content = markdown_renderer.render(article[:content])
    
    erb :admin_articles_show, :locals => { :article => article, :content => content }, :layout => :admin_layout
  end
end

post "/admin/articles" do
  protected! do
    article_params = params[:article]
    ArticleService.new(DB).create(
      article_params[:author],
      article_params[:title],
      article_params[:content] 
    )
    
    redirect to("/admin/articles")
  end
end