require "spec_helper"

describe "The editor's article edit page" do
  include Capybara::DSL

  include Pharrell::Injectable
  injected :article_service, Persistence::ArticleService

  before do
    Capybara.app = Tangent.new
    page.driver.browser.basic_authorize("admin", "admin")
  end

  it "lets the editor edit the article" do
    article_service.create(
      "Roger Ebert",
      "Computer Chess",
      Categories::FILM.id,
      "Here's a movie by nerds, for nerds, and about nerds."
    )

    visit "/editor"
    click_on "Articles"
    click_on "Computer Chess"
    click_on "Edit"

    fill_in "Author", :with => "David Chen"
    select "Life", :from => "Category"
    click_on "Save"

    expect(page).to have_content("David Chen")
    expect(page).to have_no_content("Roger Ebert")

    click_on "Categories"
    click_on "Life"
    expect(page).to have_content("David Chen")
    expect(page).to have_content("Computer Chess")
  end

  it "lets the editor delete the article" do
    article_service.create(
      "Roger Ebert",
      "Computer Chess",
      Categories::FILM.id,
      "Here's a movie by nerds, for nerds, and about nerds."
    )

    visit "/editor"
    click_on "Articles"
    click_on "Computer Chess"
    click_on "Edit"

    click_on "Delete"

    visit "/editor"
    click_on "Articles"
    expect(page).to have_no_content("Computer Chess")
  end
end
