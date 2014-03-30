require "spec_helper"

describe "An editor writing and publishing an article" do
  include Capybara::DSL

  include Pharrell::Injectable

  before do
    Capybara.app = Tangent.new
  end

  it "shows the article on the home page" do
    page.driver.browser.basic_authorize("admin", "admin")

    visit "/editor"
    click_on "Articles"

    click_on "New Article"
    fill_in "Title", :with => "Computer Chess"
    fill_in "Author", :with => "Roger Ebert"
    select "Film", :from => "Category"
    fill_in "Summary", :with => "A review about a film"
    fill_in "Content", :with => "Some stuff about the filmm\n\nAnd some more stuff."
    click_on "Save"
    click_on "Publish"

    visit "/"
    expect(page).to have_content("Computer Chess")
    expect(page).to have_content("A review about a film")

    click_on "Computer Chess"
    expect(page).to have_content("Computer Chess")
    expect(page).to have_content("Roger Ebert")
    expect(page).to have_content("Some stuff about the film")
    expect(page).to have_content("And some more stuff")
  end
end
