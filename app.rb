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

DB_URL = case ENV["RACK_ENV"]
when "test"
  "sqlite://tangent-test.db"
when "development"
  "sqlite://tangent.db"
when "production"
  ENV["DATABASE_URL"]
end

DB = Sequel.connect(DB_URL)

get '/' do
  categories = CategoryService.new(DB).fetch_all
  
  article_service = ArticleService.new(DB)
  categories_with_articles = categories.reduce([]) do |categories, category|
    articles = article_service.fetch_all_from_category(category[:id])
    
    if articles.empty?
      categories
    else
      category_with_articles = {
        :id => category[:id],
        :name => category[:name],
        :articles => articles
      }
      
      categories << category_with_articles
    end
  end
  
  erb :home, :locals => { :categories => categories_with_articles }
end

get "/articles/:id" do
  article = ArticleService.new(DB).fetch(params[:id])
  widget = Widget::Article.new(article)
  
  erb :articles_show, :locals => { :article => widget }
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
    categories = DB[:categories].all
    erb :editor_articles_new, :locals => { :categories => categories }, :layout => :editor_layout
  end
end

get '/editor/articles/:id' do
  protected! do
    article = ArticleService.new(DB).fetch(params[:id])
    widget = Widget::Article.new(article)
    
    erb :editor_articles_show, :locals => { :article => widget }, :layout => :editor_layout
  end
end

get '/editor/articles/:id/edit' do
  protected! do
    article = ArticleService.new(DB).fetch(params[:id])
    categories = DB[:categories].all
    erb :editor_articles_edit, :locals => { :article => article, :categories => categories }, :layout => :editor_layout
  end
end

post "/editor/articles" do
  protected! do
    article_params = params[:article]
    ArticleService.new(DB).create(
      article_params[:author],
      article_params[:title],
      article_params[:category],
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
      article_params[:category],
      article_params[:content] 
    )
  
    redirect to("/editor/articles/#{params[:id]}")
  end
end

get "/editor/categories" do
  protected! do
    categories = CategoryService.new(DB).fetch_all
    erb :editor_categories, :locals => { :categories => categories }, :layout => :editor_layout
  end
end

post "/editor/categories" do
  protected! do
    CategoryService.new(DB).create(params[:category][:name])
    redirect to("/editor/categories")
  end
end

get "/editor/categories/new" do
  protected! do
    erb :editor_categories_new, :layout => :editor_layout
  end
end

get "/editor/categories/:id" do
  protected! do
    category = CategoryService.new(DB).fetch(params[:id])
    articles = ArticleService.new(DB).fetch_all_from_category(category[:id])
    erb :editor_categories_show, :locals => { :category => category, :articles => articles }, :layout => :editor_layout
  end
end

get "/editor/categories/:id/edit" do
  protected! do
    category = CategoryService.new(DB).fetch(params[:id])
    erb :editor_categories_edit, :locals => { :category => category }, :layout => :editor_layout
  end
end

put "/editor/categories/:id" do
  protected! do
    CategoryService.new(DB).update(params[:id], params[:category][:name])
    redirect to("/editor/categories/#{params[:id]}")
  end
end