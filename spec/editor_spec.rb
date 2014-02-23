require "spec_helper"
require "pry"

describe Editor do
  include Rack::Test::Methods
  include Pharrell::Injectable
  
  injected :article_service, Persistence::ArticleService

  def app
    Editor
  end

  describe "POST /editor/articles/:id/publishing" do
    it "redirects to the article show page" do
      article_service.create("", "", nil, "")
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