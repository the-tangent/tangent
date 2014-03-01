require "spec_helper"

describe "The editor's article edit page" do
  include Capybara::DSL

  before do
    Capybara.app = Tangent.new
    page.driver.browser.basic_authorize("admin", "admin")
  end

  it "lets the editor edit the article" do
    visit "/editor"

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
    select "Life", :from => "Category"
    click_on "Save"

    expect(page).to have_content("David Chen")
    expect(page).to have_no_content("Roger Ebert")

    click_on "Categories"
    click_on "Life"
    expect(page).to have_content("David Chen")
    expect(page).to have_content("Computer Chess")
  end
end
