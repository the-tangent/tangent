require "spec_helper"

describe "Admin page" do
  include Capybara::DSL

  before do
    Capybara.app = Sinatra::Application.new
  end

  it "is protected" do
    visit "/admin"
    expect(page.status_code).to eq(401)
  end
  
  context "after authenticating" do    
    before do
      page.driver.browser.basic_authorize("admin", "admin")
    end
    
    it "welcomes Lisa" do
      visit "/admin"
      expect(page).to have_content("Hi Lisa :)")
    end
  end
end