require "spec_helper"

describe "The editor's category list page" do
  include Capybara::DSL

  before do
    Capybara.app = Tangent.new
    page.driver.browser.basic_authorize("admin", "admin")
  end

  it "lists the categories" do
    visit "/editor"
    click_on "Categories"

    expect(page).to have_content("Here/Now")
    expect(page).to have_content("Life")
    expect(page).to have_content("Art")
    expect(page).to have_content("Science")
    expect(page).to have_content("Film")
    expect(page).to have_content("Theatre")
  end
end
