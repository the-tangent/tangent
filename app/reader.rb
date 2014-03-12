class Reader < Base
  helpers Sinatra::Nedry

  injected :clock, System::Clock

  get "/" do
    redirect to("/home")
  end

  get "/home" do
    flagged! do
      articles = service.fetch_all
      tiles = articles.map { |a| Widget::Tile.new(a) }

      render_page :articles, :articles => tiles, :opts => { :home_active => true }
    end
  end

  get "/about/?" do
    render_page :about
  end

  get "/categories/:id/?" do
    flagged! do
      articles = service.fetch_all_from_category(params[:id])
      tiles = articles.map { |a| Widget::Tile.new(a) }

      render_page :articles, :articles => tiles, :opts => { :active_category => params[:id] }
    end
  end

  get "/articles/:id/?" do
    flagged! do
      article = service.fetch(params[:id].to_i)

      if article
        article_widget = Widget::Article.new(article)
        comments = Widget::Comments.new(ENV["RACK_ENV"])

        render_page :articles_show, :article => article_widget, :comments => comments
      else
        raise Sinatra::NotFound
      end
    end
  end

  private

  def render_page(template, locals = {})
    locals = locals.merge(:date => clock.now, :categories => Categories::ALL)
    locals[:opts] ||= {}
    erb(template, :locals => locals)
  end

  def service
    article_service.published.page(0)
  end
end
