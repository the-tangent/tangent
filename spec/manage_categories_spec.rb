require "spec_helper"

describe "An editor managing categories" do
  include Capybara::DSL

  before do
    Capybara.app = Sinatra::Application.new
  end
  
  describe "on the categories list page" do
    before do
      page.driver.browser.basic_authorize("editor", "editor")
      visit "/editor" 
    end
    
    it "can create a category" do
      click_on "Categories"
      click_on "New Category"
      
      fill_in "Name", :with => "Culture"
      click_on "Save"
      
      expect(page).to have_content("Culture")
    end
  end
end