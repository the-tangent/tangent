require "spec_helper"
require "pry"

describe "Homepage" do
  include Capybara::DSL
  include Pharrell::Injectable
  
  injected :clock, System::Clock

  before do
    Capybara.app = Sinatra::Application.new
  end

  it "lists the categories with articles" do
    create_categories("Culture", "Comment", "Sports")
    create_articles(
      ["Computer Chess", "Roger Ebert", "Culture"],
      ["Dylan Farrow Is Already Too Old", "Heather Long", "Comment"]
    )
    
    visit '/'
    expect(page).to have_content("Culture")
    expect(page).to have_content("Comment")
    
    expect(page).to have_content("Computer Chess")
    expect(page).to have_content("Roger Ebert")
    
    expect(page).to have_content("Dylan Farrow Is Already Too Old")
    expect(page).to have_content("Heather Long")
    
    expect(page).to have_no_content("Sports")
  end
  
  it "shows the current date" do
    clock.set_time("24 February 2014")
  
    visit "/"
    expect(page).to have_content("24 February 2014")
  end
  
  describe "clicking on an article" do
    it "shows the article's content" do
      create_categories("Culture")
      create_articles(
        ["Computer Chess", "Roger Ebert", "Culture", "The *best*:\n\nMovie."],
      )
      
      visit '/'
      click_on "Computer Chess"
    
      expect(page.html).to include("<p>The <em>best</em>:</p>")
      expect(page.html).to include("<p>Movie.</p>")
    end
  end
  
  def create_categories(*categories)
    page.driver.browser.basic_authorize("editor", "editor")
    visit "/editor"
    
    categories.each do |category|
      click_on "Categories"
      click_on "New Category"
  
      fill_in "Name", :with => category
      click_on "Save"
    end
    
    page.driver.browser.basic_authorize("wrong", "wrong")
  end
  
  def create_articles(*articles)
    page.driver.browser.basic_authorize("editor", "editor")
    visit "/editor"
    
    articles.each do |article|
      click_on "Articles"
      click_on "New Article"
      
      fill_in "Title", :with => article[0]
      fill_in "Author", :with => article[1] 
      fill_in "Content", :with => article[3]
      select article[2], :from => "Category"
      
      click_on "Save"
    end
    
    page.driver.browser.basic_authorize("wrong", "wrong")
  end
end