require "spec_helper"

describe "An editor managing articles" do
  include Capybara::DSL

  before do
    Capybara.app = Sinatra::Application.new
  end
  
  describe "on the article list page" do
    before do
      page.driver.browser.basic_authorize("editor", "editor")
      visit "/editor" 
    end
    
    it "can create an article" do
      click_on "Articles"
      click_on "New Article"
      
      fill_in "Author", :with => "Roger Ebert"
      fill_in "Title", :with => "Computer Chess"
      fill_in "Content", :with => "Here's a movie by nerds, for nerds, and about nerds."
      
      click_on "Save"
      expect(page).to have_content("Roger Ebert")
      expect(page).to have_content("Computer Chess")
    end
    
    describe "clicking on an article" do
      it "sees the article rendered content" do
        click_on "Articles"
        click_on "New Article"
      
        fill_in "Author", :with => "Roger Ebert"
        fill_in "Title", :with => "Computer Chess"
        fill_in "Content", :with => "Here is a movie by nerds, for *nerds*.\n\nAnd, about nerds."
      
        click_on "Save"
        click_on "Computer Chess"
        
        expect(page.html).to include("<p>Here is a movie by nerds, for <em>nerds</em>.</p>")
        expect(page.html).to include("<p>And, about nerds.</p>")
      end
    end
  end
end