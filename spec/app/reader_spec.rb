require "spec_helper"

describe Reader do
  include Rack::Test::Methods
  include Pharrell::Injectable

  injected :article_service, Persistence::ArticleService

  def app
    Reader
  end

  describe "GET /articles/:id" do
    it "shows a 404 if the article doesn't exist" do
      get "/articles/5"
      expect(last_response).to be_not_found
    end

    context "the article is unpublished" do
      it "returns a 404" do
        article_id = article_service.create(
          "Roger Ebert",
          "Computer Chess",
          Categories::FILM.id,
          "summary",
          "blah blah"
        )

        get "/articles/#{article_id}"
        expect(last_response).to be_not_found
      end
    end
  end

  describe "GET /about" do
    it "returns a success" do
      get "/about"
      expect(last_response).to be_ok
    end
  end

  describe "GET /people" do
    it "returns a success" do
      get "/people"
      expect(last_response).to be_ok
    end
  end
end
