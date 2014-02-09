require "spec_helper"
require "pry"

describe "An editor managing articles" do
  include Capybara::DSL

  before do
    Capybara.app = Tangent.new
  end
  
  describe "on the article list page" do
    before do
      page.driver.browser.basic_authorize("editor", "editor")
      visit "/editor" 
      
      click_on "Categories"
      click_on "New Category"
      
      fill_in "Name", :with => "Film"
      click_on "Save"
    end
    
    it "can create an article" do  
      click_on "Articles"
      click_on "New Article"
      
      fill_in "Author", :with => "Roger Ebert"
      fill_in "Title", :with => "Computer Chess"
      fill_in "Content", :with => "Here's a movie by nerds, for nerds, and about nerds."
      select "Film", :from => "Category"
      
      click_on "Save"
      expect(page).to have_content("Roger Ebert")
      expect(page).to have_content("Computer Chess")
      
      click_on "Categories"
      click_on "Film"
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
        select "Film", :from => "Category"
      
        click_on "Save"
        click_on "Computer Chess"
        
        expect(page.html).to include("<p>Here is a movie by nerds, for <em>nerds</em>.</p>")
        expect(page.html).to include("<p>And, about nerds.</p>")
      end
      
      it "lets the editor edit the article" do
        click_on "Categories"
        click_on "New Category"
      
        fill_in "Name", :with => "Culture"
        click_on "Save"
        
        click_on "Articles"
        click_on "New Article"
      
        fill_in "Author", :with => "Roger Ebert"
        fill_in "Title", :with => "Computer Chess"
        fill_in "Content", :with => "Here is a movie by nerds, for *nerds*.\n\nAnd, about nerds."
        select "Film", :from => "Category"
      
        click_on "Save"
        click_on "Computer Chess"      
        click_on "Edit"
        
        fill_in "Author", :with => "David Chen"
        select "Culture", :from => "Category"
        click_on "Save"
        
        expect(page).to have_content("David Chen")
        expect(page).to have_no_content("Roger Ebert")
        
        click_on "Categories"
        click_on "Culture"
        expect(page).to have_content("David Chen")
        expect(page).to have_content("Computer Chess")
      end
    end
  end
end