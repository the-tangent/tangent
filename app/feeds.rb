class Feeds < Base
  helpers Sinatra::Nedry

  include Pharrell::Injectable
  injected :article_service, Persistence::ArticleService

  get "/feeds/articles" do
    flagged! do
      @articles = article_service.published.fetch_all.take(20)
      builder :articles
    end
  end
end
