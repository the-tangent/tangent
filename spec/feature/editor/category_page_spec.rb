require "spec_helper"

describe "The editor's category page" do
  include Capybara::DSL

  include Pharrell::Injectable
  injected :article_service, Persistence::ArticleService

  before do
    Capybara.app = Tangent.new
    page.driver.browser.basic_authorize("admin", "admin")
  end

  it "lists the articles for that category" do
    article_service.create(
      "Roger Ebert",
      "Computer Chess",
      Categories::FILM.id,
      "Heres a movie by nerds,\r\n\r\nFor nerds, and about nerds."
    )

    visit "/editor"
    click_on "Categories"
    click_on "Film"

    expect(page).to have_content("Computer Chess")
  end

  describe "clicking on an article" do
    it "shows the article" do
      article_service.create(
        "Roger Ebert",
        "Computer Chess",
        Categories::FILM.id,
        "Heres a movie by nerds,\r\n\r\nFor nerds, and about nerds."
      )

      visit "/editor"
      click_on "Categories"
      click_on "Film"
      click_on "Computer Chess"

      expect(page).to have_content("Heres a movie by nerds")
    end
  end

  describe "clicking on New Article" do
    it "lets the editor create an article" do
      visit "/editor"
      click_on "Categories"
      click_on "Here/Now"

      click_on "New Article"
      fill_in "Title", :with => "Computer Chess"
      click_on "Save"

      expect(page).to have_content("Computer Chess")
    end
  end
end
