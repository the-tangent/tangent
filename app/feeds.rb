class Feeds < Base
  helpers Sinatra::Nedry
  
  injected :article_service, Persistence::ArticleService

  get "/rss.xml" do
    @articles = article_service.published.page(0, :per_page => 20).fetch_all.map do |article|
      Widget::ArticleRssItem.new(article)
    end

    builder :articles
  end
end
