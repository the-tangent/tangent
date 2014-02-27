class Reader < Base
  helpers Sinatra::Nedry

  get "/" do
    redirect to("/home")
  end

  get "/home" do
    flagged! do
      categories = category_service.fetch_all

      articles = article_service.published.fetch_all
      tiles = articles.map { |a| Widget::Tile.new(a) }

      erb :articles, :locals => { :categories => categories, :articles => tiles }
    end
  end

  get "/categories/:id/?" do
    flagged! do
      categories = category_service.fetch_all

      articles = article_service.published.fetch_all_from_category(params[:id])
      tiles = articles.map { |a| Widget::Tile.new(a) }

      erb :articles, :locals => { :categories => categories, :articles => tiles }
    end
  end

  get "/articles/:id/?" do
    flagged! do
      categories = category_service.fetch_all
      article = article_service.published.fetch(params[:id])

      article_widget = Widget::Article.new(article)
      comments = Widget::Comments.new(ENV["RACK_ENV"])

      erb :articles_show, :locals => {
        :categories => categories,
        :article => article_widget,
        :comments => comments
      }
    end
  end
end
