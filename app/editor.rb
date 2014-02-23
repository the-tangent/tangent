class Editor < Base
  helpers Sinatra::Nedry
  
  before do
    if ENV["RACK_ENV"] == "production" && request.scheme == "http"
      redirect to("https://#{ENV["HOSTNAME"]}#{request.path}")
    end
  end
  
  get '/editor/?' do
    protected! do
      erb :editor, :layout => :editor_layout
    end
  end

  get '/editor/articles/?' do
    protected! do
      articles = article_service.fetch_all
      erb :editor_articles, :locals => { :articles => articles }, :layout => :editor_layout
    end
  end

  get '/editor/articles/new/?' do
    protected! do
      categories = category_service.fetch_all
      erb :editor_articles_new, :locals => { :categories => categories }, :layout => :editor_layout
    end
  end

  get '/editor/articles/:id/?' do
    protected! do
      article = article_service.fetch(params[:id])
      widget = Widget::Article.new(article)
    
      erb :editor_articles_show, :locals => { :article => widget }, :layout => :editor_layout
    end
  end

  get '/editor/articles/:id/edit/?' do
    protected! do
      article = article_service.fetch(params[:id])
      categories = category_service.fetch_all
      erb :editor_articles_edit, :locals => { :article => article, :categories => categories }, :layout => :editor_layout
    end
  end

  post "/editor/articles/?" do
    protected! do
      article_params = params[:article]
      article_service.create(
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
      article_service.update(params[:id],
        article_params[:author],
        article_params[:title],
        article_params[:category],
        article_params[:content] 
      )
  
      redirect to("/editor/articles/#{params[:id]}")
    end
  end
  
  post "/editor/articles/:id/publishing/?" do
    protected! do
      article_service.publish(params[:id])
      redirect to("/editor/articles/#{params[:id]}")
    end
  end
  
  delete "/editor/articles/:id/publishing/?" do
    protected! do
      article_service.unpublish(params[:id])
      redirect to("/editor/articles/#{params[:id]}")
    end
  end

  get "/editor/categories/?" do
    protected! do
      categories = category_service.fetch_all
      erb :editor_categories, :locals => { :categories => categories }, :layout => :editor_layout
    end
  end

  post "/editor/categories/?" do
    protected! do
      category_service.create(params[:category][:name])
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
      category = category_service.fetch(params[:id])
      articles = article_service.fetch_all_from_category(category.id)
      erb :editor_categories_show, :locals => { :category => category, :articles => articles }, :layout => :editor_layout
    end
  end

  get "/editor/categories/:id/edit/?" do
    protected! do
      category = category_service.fetch(params[:id])
      erb :editor_categories_edit, :locals => { :category => category }, :layout => :editor_layout
    end
  end

  put "/editor/categories/:id/?" do
    protected! do
      category_service.update(params[:id], params[:category][:name])
      redirect to("/editor/categories/#{params[:id]}")
    end
  end
end