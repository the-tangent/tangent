require "spec_helper"
require "pry"

describe "Homepage" do
  include Capybara::DSL
  include Pharrell::Injectable

  injected :article_service, Persistence::ArticleService

  before do
    Capybara.app = Tangent.new
  end

  it "lists articles with summaries" do
    create_articles(
      ["Computer Chess", "Roger Ebert", "A good film\n\nAnother thing"],
      ["Dylan Farrow Is Already Too Old", "Heather Long", "Oh my god Woody Allen\n\nAnother thing"]
    )

    visit '/'

    expect(page).to have_content("Computer Chess")
    expect(page).to have_content("A good film")

    expect(page).to have_content("Dylan Farrow Is Already Too Old")
    expect(page).to have_content("Oh my god Woody Allen")

    expect(page).to have_no_content("Another thing")
  end

  describe "clicking on an article" do
    it "shows the article's content" do
      create_articles(
        ["Computer Chess", "Roger Ebert", "The *best*:\n\nMovie."],
      )

      visit '/'
      click_on "Computer Chess"

      expect(page.html).to include("<p>The <em>best</em>:</p>")
      expect(page.html).to include("<p>Movie.</p>")
    end
  end

  describe "clicking on a category" do
    it "shows articles for that category" do
      create_categories("Film", "Other")
      create_articles(
        ["Other Category Article", "Some Person", "", "Other"],
        ["Computer Chess", "Roger Ebert", "The *best*:\n\nMovie.", "Film"],
      )

      visit '/'
      click_on "Film"
      expect(page).to have_content("Computer Chess")
      expect(page).to have_no_content("Other Category Article")
    end
  end

  def create_categories(*categories)
    page.driver.browser.basic_authorize("admin", "admin")
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
    page.driver.browser.basic_authorize("admin", "admin")

    articles.each do |article|
      visit "/editor"
      click_on "Articles"
      click_on "New Article"

      fill_in "Title", :with => article[0]
      fill_in "Author", :with => article[1]
      fill_in "Content", :with => article[2]
      select article[3], :from => "Category" if article[3]

      click_on "Save"
      click_on article[0]
      click_on "Publish"
    end

    page.driver.browser.basic_authorize("wrong", "wrong")
  end
end
