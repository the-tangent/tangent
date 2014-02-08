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
    editor_credentials = if ENV["RACK_ENV"] == "production"
      [ENV["ADMIN_USERNAME"], ENV["ADMIN_PASSWORD"]]
    else
      ["editor", "editor"]
    end      
    
    @auth ||=  Rack::Auth::Basic::Request.new(request.env)
    @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == editor_credentials
  end
end

DB = Sequel.connect(ENV["DATABASE_URL"] || "sqlite://tangent.db")

get '/' do
  erb :home
end

get '/editor' do
  protected! do
    erb :editor, :layout => :editor_layout
  end
end

get '/editor/articles' do
  protected! do
    articles = ArticleService.new(DB).fetch_all
    erb :editor_articles, :locals => { :articles => articles }, :layout => :editor_layout
  end
end

get '/editor/articles/new' do
  protected! do
    erb :editor_articles_new, :layout => :editor_layout
  end
end

get '/editor/articles/:id' do
  protected! do
    article = ArticleService.new(DB).fetch(params[:id])
    
    markdown_renderer = ::Redcarpet::Markdown.new(Redcarpet::Render::HTML)
    content = markdown_renderer.render(article[:content])
    
    erb :editor_articles_show, :locals => { :article => article, :content => content }, :layout => :editor_layout
  end
end

get '/editor/articles/:id/edit' do
  protected! do
    article = ArticleService.new(DB).fetch(params[:id])  
    erb :editor_articles_edit, :locals => { :article => article }, :layout => :editor_layout
  end
end

post "/editor/articles" do
  protected! do
    article_params = params[:article]
    ArticleService.new(DB).create(
      article_params[:author],
      article_params[:title],
      article_params[:content] 
    )

    redirect to("/editor/articles")
  end
end

put "/editor/articles/:id" do
  protected! do
    article_params = params[:article]
    article = ArticleService.new(DB).update(params[:id],
      article_params[:author],
      article_params[:title],
      article_params[:content] 
    )
  
    redirect to("/editor/articles/#{params[:id]}")
  end
end