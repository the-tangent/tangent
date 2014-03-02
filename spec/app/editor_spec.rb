require "spec_helper"

describe Editor do
  include Rack::Test::Methods
  include Pharrell::Injectable

  injected :article_service, Persistence::ArticleService

  def app
    Editor
  end

  describe "POST /editor/articles" do
    it "uploads files under a scope" do
      authorize "admin", "admin"
      post "/editor/articles", :article => {
        :image => Rack::Test::UploadedFile.new(File.expand_path("spec/fixtures/files/test.png"), "image/png")
      }

      article = article_service.fetch_all.first
      expect(article.image_url).to include("/article#{article.id}-test.png")
    end
  end

  describe "PUT /editor/articles" do
    it "uploads files under a scope" do
      id = article_service.create("Roger Ebert", "Computers", Categories::FILM.id, "Some stuff")

      authorize "admin", "admin"
      put "/editor/articles/#{id}", :article => {
        :image => Rack::Test::UploadedFile.new(File.expand_path("spec/fixtures/files/test.png"), "image/png")
      }

      article = article_service.fetch_all.first
      expect(article.image_url).to include("/article#{article.id}-test.png")
    end
  end

  describe "POST /editor/articles/:id/publishing" do
    it "redirects to the article show page" do
      article_service.create("Roger Ebert", "Computers", Categories::FILM.id, "Some stuff")
      id = article_service.fetch_all.first.id

      authorize "admin", "admin"
      post "/editor/articles/#{id}/publishing"

      expect(last_response).to be_redirect
      expect(last_response.location).to include("/editor/articles/#{id}")
    end
  end

  describe "DELETE /editor/articles/:id/publishing" do
    it "redirects to the article show page" do
      article_service.create("", "", nil, "")
      id = article_service.fetch_all.first.id

      authorize "admin", "admin"
      delete "/editor/articles/#{id}/publishing"

      expect(last_response).to be_redirect
      expect(last_response.location).to include("/editor/articles/#{id}")
    end
  end
end
