class Reader < Base
  injected :clock, System::Clock
  
  get '/' do
    categories = category_service.fetch_all(:articles => article_service)
    date = clock.now
  
    erb :home, :locals => { :categories => categories, :date => date }
  end

  get "/articles/:id/?" do
    article = article_service.fetch(params[:id])
    widget = Widget::Article.new(article)
  
    erb :articles_show, :locals => { :article => widget }
  end
end