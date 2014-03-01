require "spec_helper"

describe Reader do
  include Rack::Test::Methods

  def app
    Reader
  end

  describe "GET /articles/:id" do
    it "shows a 404 if the article doesn't exist" do
      get "/articles/5"
      expect(last_response).to be_not_found
    end
  end
end
