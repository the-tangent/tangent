require "spec_helper"

describe "The editor's article show page" do
  include Capybara::DSL

  include Pharrell::Injectable
  injected :article_service, Persistence::ArticleService

  before do
    Capybara.app = Tangent.new
    page.driver.browser.basic_authorize("admin", "admin")
  end

  it "shows the rendered article" do
    article_service.create(
      "Roger Ebert",
      "Computer Chess",
      Categories::FILM.id,
      "Heres a movie by nerds,\r\n\r\nFor nerds, and about nerds."
    )

    visit "/editor"
    click_on "Articles"
    click_on "Computer Chess"

    expect(page).to have_content("Computer Chess")
    expect(page).to have_content("Roger Ebert")
    expect(page.html).to include("<p>Heres a movie by nerds,</p>")
    expect(page.html).to include("<p>For nerds, and about nerds.</p>")
  end

  describe "clicking on publish" do
    it "publishes/unpublishes articles" do
      article_service.create(
        "Roger Ebert",
        "Computer Chess",
        Categories::FILM.id,
        "Here's a movie by nerds, for nerds, and about nerds."
      )

      visit "/editor"
      click_on "Articles"
      click_on "Computer Chess"

      click_on "Publish"

      visit "/"
      expect(page).to have_content("Computer Chess")

      visit "/editor"
      click_on "Articles"
      click_on "Published"
      click_on "Computer Chess"

      click_on "Unpublish"

      visit "/"
      expect(page).to have_no_content("Computer Chess")
    end

    it "shows an error if an unfinished article is published" do
      article_service.create(
        "",
        "Computer Chess",
        Categories::FILM.id,
        "Here's a movie by nerds, for nerds, and about nerds."
      )

      visit "/editor"
      click_on "Articles"
      click_on "Computer Chess"

      click_on "Publish"
      expect(page).to have_content("not finished")

      visit "/"
      expect(page).to have_no_content("Computer Chess")
    end
  end
end
