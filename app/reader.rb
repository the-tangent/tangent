class Reader < Base
  helpers Sinatra::Nedry

  get "/" do
    redirect to("/home")
  end

  get "/home" do
    flagged! do
      categories = category_service.fetch_all

      articles = article_service.fetch_all.select { |a| a.published }
      tiles = articles.map { |a| Widget::Tile.new(a) }

      erb :articles, :locals => { :categories => categories, :articles => tiles }
    end
  end

  get "/categories/:id/?" do
    flagged! do
      categories = category_service.fetch_all

      articles = article_service.fetch_all_from_category(params[:id])
      published_articles = articles.select { |a| a.published }
      tiles = published_articles.map { |a| Widget::Tile.new(a) }

      erb :articles, :locals => { :categories => categories, :articles => tiles }
    end
  end

  get "/articles/:id/?" do
    flagged! do
      categories = category_service.fetch_all

      article = article_service.fetch(params[:id])
      widget = Widget::Article.new(article)

      erb :articles_show, :locals => { :article => widget, :categories => categories }
    end
  end
end
