class Reader < Base
  injected :clock, System::Clock
   
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
      date = clock.now

      erb :home, :locals => { :categories => categories, :date => date }
    end
  end
  
  get "/articles/:id/?" do
    flagged! do
      article = article_service.fetch(params[:id])
      widget = Widget::Article.new(article)
  
      erb :articles_show, :locals => { :article => widget }
    end
  end
  
  def flagged!(&blk)
    auth = Http::BasicAuth.new(request, ENV["RACK_ENV"], ENV["ADMIN_USERNAME"], ENV["ADMIN_PASSWORD"])
  
    if auth.authorized? || ENV["RACK_ENV"] != "production"
      blk.call
    else
      not_authorized
    end
  end
end