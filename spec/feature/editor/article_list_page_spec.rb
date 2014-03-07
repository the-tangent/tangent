require "spec_helper"

describe "The editor's article list page" do
  include Capybara::DSL

  include Pharrell::Injectable
  injected :article_service, Persistence::ArticleService
  injected :clock, System::Clock

  before do
    Capybara.app = Tangent.new
    page.driver.browser.basic_authorize("admin", "admin")
  end

  it "lists the unpublished articles" do
    article_service.create("Richard Riddick", "Surviving Crematoria", nil, nil)
    article_service.create("John Rambo", "Killing Folk", nil, nil)
    id = article_service.create("Jean Claude Van Damme", "Kicking People", nil, nil)

    article_service.publish(id, clock.now)

    visit "/editor"
    click_on "Articles"
    click_on "Unpublished"

    expect(page).to have_no_content("Kicking People")
    expect(page).to have_no_content("Jean Claude Van Damme")

    expect(page).to have_content("Surviving Crematoria")
    expect(page).to have_content("Richard Riddick")

    expect(page).to have_content("Killing Folk")
    expect(page).to have_content("John Rambo")
  end

  it "lists the published articles" do
    ids = []
    ids << article_service.create("Richard Riddick", "Surviving Crematoria", nil, nil)
    ids << article_service.create("John Rambo", "Killing Folk", nil, nil)
    article_service.create("Jean Claude Van Damme", "Kicking People", nil, nil)

    ids.each { |id| article_service.publish(id, clock.now) }

    visit "/editor"
    click_on "Articles"
    click_on "Published"

    expect(page).to have_no_content("Kicking People")
    expect(page).to have_no_content("Jean Claude Van Damme")

    expect(page).to have_content("Surviving Crematoria")
    expect(page).to have_content("Richard Riddick")

    expect(page).to have_content("Killing Folk")
    expect(page).to have_content("John Rambo")
  end

  describe "clicking on New Article" do
    it "lets the editor create an article" do
      visit "/editor"
      click_on "Articles"

      click_on "New Article"
      fill_in "Title", :with => "Computer Chess"
      fill_in "Author", :with => "Roger Ebert"
      select "Film", :from => "Category"
      fill_in "Content", :with => "Here's a movie by nerds, for nerds, and about nerds."
      click_on "Save"

      click_on "Articles"
      expect(page).to have_content("Roger Ebert")
      expect(page).to have_content("Computer Chess")

      click_on "Categories"
      click_on "Film"
      expect(page).to have_content("Roger Ebert")
      expect(page).to have_content("Computer Chess")
    end
  end
end
