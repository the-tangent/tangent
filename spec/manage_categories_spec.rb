require "spec_helper"

describe "An editor managing categories" do
  include Capybara::DSL

  before do
    Capybara.app = Tangent.new
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
    
    describe "clicking on a category" do
      it "lets the editor edit the category" do
        click_on "Categories"
        click_on "New Category"
      
        fill_in "Name", :with => "Culture"
        click_on "Save"
        
        click_on "Culture"
        click_on "Edit"
        
        fill_in "Name", :with => "Arts"
        click_on "Save"
        
        expect(page).to have_content("Arts")
        expect(page).to have_no_content("Culture")
      end
    end
  end
end