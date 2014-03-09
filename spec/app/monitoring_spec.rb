require "spec_helper"

describe Monitoring do
  include Rack::Test::Methods

  def app
    Monitoring
  end

  describe "GET /ping" do
    it "says pong" do
      get "/ping"

      expect(last_response).to be_ok
      expect(last_response.body).to include("pong")
    end
  end
end
