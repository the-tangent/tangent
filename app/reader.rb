class Reader < Base
  helpers Sinatra::Nedry

  injected :clock, System::Clock
  injected :article_service, Persistence::ArticleService
  injected :article_search_service, Persistence::ArticleSearchService

  get "/" do
    articles = service.fetch_all
    tiles = articles.map { |a| Widget::Tile.new(a) }

    render_page :articles, :articles => tiles, :opts => { :home_active => true }
  end

  get "/categories/:id/?" do
    articles = service.fetch_all_from_category(params[:id])
    tiles = articles.map { |a| Widget::Tile.new(a) }

    render_page :articles, :articles => tiles, :opts => { :active_category => params[:id] }
  end

  get "/articles/:id/?" do
    article = article_service.fetch(params[:id].to_i)

    if article
      article_widget = Widget::Article.new(article)
      comments = Widget::Comments.new(ENV["RACK_ENV"])

      render_page :articles_show, {
        :article => article_widget,
        :comments => comments,
        :opts => {
          :title => article.title,
          :active_category => article.category_id
        }
      }
    else
      raise Sinatra::NotFound
    end
  end

  get "/search/?" do
    results = article_search_service.search(params[:query])
    tiles = results.map { |result| Widget::Tile.new(result) }
    render_page :articles, :articles => tiles, :opts => {
      :title => params[:query],
      :query => params[:query]
    }
  end

  get "/about/?" do
    render_page :about
  end

  get "/people/?" do
    flagged! do
      render_page :people
    end
  end

  private

  def render_page(template, locals = {})
    locals = locals.merge(:date => clock.now, :categories => Categories::ALL)
    locals[:opts] ||= {}
    erb(template, :locals => locals)
  end

  def service
    article_service.published.page(0, :per_page => 9)
  end
end
