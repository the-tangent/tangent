class Reader < Base
  injected :clock, System::Clock
   
  get "/" do
    if ENV["RACK_ENV"] == "production"
      redirect_to("/manifesto")
    else
      redirect to("/home")
    end
  end
  
  get "/home" do
    categories = category_service.fetch_all(:articles => article_service)
    date = clock.now

    erb :home, :locals => { :categories => categories, :date => date }
  end
  
  get "/manifesto" do
    erb :manifesto
  end
  
  get "/articles/:id/?" do
    article = article_service.fetch(params[:id])
    widget = Widget::Article.new(article)
  
    erb :articles_show, :locals => { :article => widget }
  end
end