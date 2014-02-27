class Reader < Base
  helpers Sinatra::Nedry
   
  get "/" do
    if ENV["RACK_ENV"] == "production"
      redirect to("/manifesto")
    else
      redirect to("/home")
    end
  end
  
  get "/manifesto" do
    erb :manifesto
  end
  
  get "/home" do
    flagged! do
      categories = category_service.fetch_all
      
      articles = article_service.fetch_all.select { |a| a.published }
      tiles = articles.map { |a| Widget::Tile.new(a) }
      
      erb :home, :locals => { :categories => categories, :articles => tiles }
    end
  end
  
  get "/categories/:id/?" do
    flagged! do
      categories = category_service.fetch_all
      
      articles = article_service.fetch_all_from_category(params[:id]).select { |a| a.published }
      tiles = articles.map { |a| Widget::Tile.new(a) }
      
      erb :home, :locals => { :categories => categories, :articles => tiles }
    end
  end
  
  get "/articles/:id/?" do
    flagged! do
      article = article_service.fetch(params[:id])
      widget = Widget::Article.new(article)
  
      erb :articles_show, :locals => { :article => widget }
    end
  end
end