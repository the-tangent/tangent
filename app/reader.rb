class Reader < Base
  helpers Sinatra::Nedry
  
  before do
    if ENV["RACK_ENV"] == "production" && request.host != ENV["DOMAIN"]
      redirect to("http://#{ENV["DOMAIN"]}#{request.path}")
    end
  end
   
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
      categories = category_service.fetch_all(:articles => article_service)
      erb :home, :locals => { :categories => categories }
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