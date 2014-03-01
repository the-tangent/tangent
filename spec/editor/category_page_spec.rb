require "spec_helper"

describe "The editor's category page" do
  include Capybara::DSL

  before do
    Capybara.app = Tangent.new
    page.driver.browser.basic_authorize("admin", "admin")
  end

  it "lists the articles for that category" do
    pending
  end

  describe "clicking on an article" do
    it "shows the article" do
      pending
    end
  end
end
