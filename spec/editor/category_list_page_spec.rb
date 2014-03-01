require "spec_helper"

describe "The editor's category list page" do
  include Capybara::DSL

  before do
    Capybara.app = Tangent.new
    page.driver.browser.basic_authorize("admin", "admin")
  end

  it "lists the categories" do
    pending
  end
end
