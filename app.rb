require 'sinatra'
require 'sequel'

DB = Sequel.connect(ENV["DATABASE_URL"] || "sqlite://tangent.db")

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

get '/' do
  "We're not going to pay you..."
end

get '/admin' do
  protected! do
    erb :admin
  end
end

get '/admin/articles' do
  protected! do
    articles = DB[:articles].all
    erb :admin_articles, :locals => { :articles => articles }
  end
end

get '/admin/articles/new' do
  protected! do
    erb :admin_articles_new
  end
end

post "/admin/articles" do
  protected! do
    article_params = params[:article]
    
    DB[:articles].insert(
      :author => article_params[:author],
      :title => article_params[:title],
      :content => article_params[:content]
    )
    
    redirect to("/admin/articles")
  end
end