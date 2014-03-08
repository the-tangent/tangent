class Reader < Base
  helpers Sinatra::Nedry

  get "/" do
    redirect to("/home")
  end

  get "/home" do
    flagged! do
      articles = service.fetch_all
      tiles = articles.map { |a| Widget::Tile.new(a) }

      erb :articles, :locals => { :categories => Categories::ALL, :articles => tiles }
    end
  end

  get "/about/?" do
    erb :about,:locals => { :categories => Categories::ALL }
  end

  get "/categories/:id/?" do
    flagged! do
      articles = service.fetch_all_from_category(params[:id])
      tiles = articles.map { |a| Widget::Tile.new(a) }

      erb :articles, :locals => { :categories => Categories::ALL, :articles => tiles }
    end
  end

  get "/articles/:id/?" do
    flagged! do
      article = service.fetch(params[:id].to_i)

      if article
        article_widget = Widget::Article.new(article)
        comments = Widget::Comments.new(ENV["RACK_ENV"])

        erb :articles_show, :locals => {
          :categories => Categories::ALL,
          :article => article_widget,
          :comments => comments
        }
      else
        raise Sinatra::NotFound
      end
    end
  end

  private

  def service
    article_service.published.page(1)
  end
end
