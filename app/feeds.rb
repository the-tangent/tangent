class Feeds < Base
  helpers Sinatra::Nedry

  include Pharrell::Injectable
  injected :article_service, Persistence::ArticleService

  get "/rss.xml" do
    @articles = article_service.published.page(0, :per_page => 20).fetch_all.map do |article|
      Widget::RssItem.new(article)
    end

    builder :articles
  end
end
