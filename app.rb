require "sinatra"
require "sequel"
require "redcarpet"
require "pharrell"

require "./lib/all"
require "./config"

get '/' do
  categories = Persistence::CategoryService.new(DB).fetch_all
  
  article_service = Persistence::ArticleService.new(DB)
  categories_with_articles = categories.reduce([]) do |categories, category|
    articles = article_service.fetch_all_from_category(category.id)
    
    if articles.empty?
      categories
    else
      category_with_articles = {
        :id => category.id,
        :name => category.name,
        :articles => articles
      }
      
      categories << Persistence::Model.new(category_with_articles)
    end
  end
  
  date = clock.now.strftime("%e %B %Y")
  
  erb :home, :locals => { :categories => categories_with_articles, :date => date }
end

get "/articles/:id/?" do
  article = Persistence::ArticleService.new(DB).fetch(params[:id])
  widget = Widget::Article.new(article)
  
  erb :articles_show, :locals => { :article => widget }
end

get '/editor/?' do
  protected! do
    erb :editor, :layout => :editor_layout
  end
end

get '/editor/articles/?' do
  protected! do
    articles = Persistence::ArticleService.new(DB).fetch_all
    erb :editor_articles, :locals => { :articles => articles }, :layout => :editor_layout
  end
end

get '/editor/articles/new/?' do
  protected! do
    categories = Persistence::CategoryService.new(DB).fetch_all
    erb :editor_articles_new, :locals => { :categories => categories }, :layout => :editor_layout
  end
end

get '/editor/articles/:id/?' do
  protected! do
    article = Persistence::ArticleService.new(DB).fetch(params[:id])
    widget = Widget::Article.new(article)
    
    erb :editor_articles_show, :locals => { :article => widget }, :layout => :editor_layout
  end
end

get '/editor/articles/:id/edit/?' do
  protected! do
    article = Persistence::ArticleService.new(DB).fetch(params[:id])
    categories = Persistence::CategoryService.new(DB).fetch_all
    erb :editor_articles_edit, :locals => { :article => article, :categories => categories }, :layout => :editor_layout
  end
end

post "/editor/articles/?" do
  protected! do
    article_params = params[:article]
    Persistence::ArticleService.new(DB).create(
      article_params[:author],
      article_params[:title],
      article_params[:category],
      article_params[:content]
    )

    redirect to("/editor/articles")
  end
end

put "/editor/articles/:id/?" do
  protected! do
    article_params = params[:article]
    Persistence::ArticleService.new(DB).update(params[:id],
      article_params[:author],
      article_params[:title],
      article_params[:category],
      article_params[:content] 
    )
  
    redirect to("/editor/articles/#{params[:id]}")
  end
end

get "/editor/categories/?" do
  protected! do
    categories = Persistence::CategoryService.new(DB).fetch_all
    erb :editor_categories, :locals => { :categories => categories }, :layout => :editor_layout
  end
end

post "/editor/categories/?" do
  protected! do
    Persistence::CategoryService.new(DB).create(params[:category][:name])
    redirect to("/editor/categories")
  end
end

get "/editor/categories/new/?" do
  protected! do
    erb :editor_categories_new, :layout => :editor_layout
  end
end

get "/editor/categories/:id/?" do
  protected! do
    category = Persistence::CategoryService.new(DB).fetch(params[:id])
    articles = Persistence::ArticleService.new(DB).fetch_all_from_category(category.id)
    erb :editor_categories_show, :locals => { :category => category, :articles => articles }, :layout => :editor_layout
  end
end

get "/editor/categories/:id/edit/?" do
  protected! do
    category = Persistence::CategoryService.new(DB).fetch(params[:id])
    erb :editor_categories_edit, :locals => { :category => category }, :layout => :editor_layout
  end
end

put "/editor/categories/:id/?" do
  protected! do
    Persistence::CategoryService.new(DB).update(params[:id], params[:category][:name])
    redirect to("/editor/categories/#{params[:id]}")
  end
end

def protected!(&blk)
  auth = Http::BasicAuth.new(request, ENV["RACK_ENV"], ENV["ADMIN_USERNAME"], ENV["ADMIN_PASSWORD"])
  
  if auth.authorized?
    blk.call
  else
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, "Not authorized\n"
  end
end

def clock
  Pharrell.instance_for(System::Clock)
end