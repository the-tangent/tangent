require "spec_helper"

describe "An admin managing articles" do
  include Capybara::DSL

  before do
    Capybara.app = Sinatra::Application.new
  end
  
  describe "on the article list page" do
    before do
      page.driver.browser.basic_authorize("admin", "admin")
      visit "/admin" 
    end
    
    it "can create an article" do
      click_on "View Articles"
      click_on "New Article"
      
      fill_in "Author", :with => "Roger Ebert"
      fill_in "Title", :with => "Computer Chess"
      fill_in "Content", :with => "Here's a movie by nerds, for nerds, and about nerds."
      
      click_on "Save"
      expect(page).to have_content("Roger Ebert")
      expect(page).to have_content("Computer Chess")
    end
  end
end