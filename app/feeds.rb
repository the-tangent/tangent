class Feeds < Base
  helpers Sinatra::Nedry

  include Pharrell::Injectable
  injected :article_service, Persistence::ArticleService

  get "/rss.xml" do
    flagged! do
      @articles = article_service.published.fetch_all.take(20).map do |article|
        Widget::RssItem.new(article)
      end

      builder :articles
    end
  end
end
