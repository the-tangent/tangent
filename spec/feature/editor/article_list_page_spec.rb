require "spec_helper"

describe "The editor's article list page" do
  include Capybara::DSL

  include Pharrell::Injectable
  injected :article_service, Persistence::ArticleService

  before do
    Capybara.app = Tangent.new
    page.driver.browser.basic_authorize("admin", "admin")
  end

  it "lists the articles" do
    article_service.create("Richard Riddick", "Surviving Crematoria", nil, nil)
    article_service.create("John Rambo", "Killing Folk", nil, nil)

    visit "/editor"
    click_on "Articles"

    expect(page).to have_content("Surviving Crematoria")
    expect(page).to have_content("Richard Riddick")

    expect(page).to have_content("Killing Folk")
    expect(page).to have_content("John Rambo")
  end

  it "lets the editor create an article" do
    visit "/editor"
    click_on "Articles"

    click_on "New Article"
    fill_in "Title", :with => "Computer Chess"
    fill_in "Author", :with => "Roger Ebert"
    select "Film", :from => "Category"
    fill_in "Content", :with => "Here's a movie by nerds, for nerds, and about nerds."
    click_on "Save"

    expect(page).to have_content("Roger Ebert")
    expect(page).to have_content("Computer Chess")

    click_on "Categories"
    click_on "Film"
    expect(page).to have_content("Roger Ebert")
    expect(page).to have_content("Computer Chess")
  end
end
