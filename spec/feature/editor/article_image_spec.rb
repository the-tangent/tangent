require "spec_helper"

describe "Uploading images for an article" do
  include Capybara::DSL

  include Pharrell::Injectable
  injected :article_service, Persistence::ArticleService

  before do
    Capybara.app = Tangent.new
    page.driver.browser.basic_authorize("admin", "admin")
  end

  it "can be done on create" do
    visit "/editor"
    click_on "Articles"

    click_on "New Article"
    fill_in "Title", :with => "Computer Chess"
    fill_in "Author", :with => "Roger Ebert"
    select "Film", :from => "Category"
    fill_in "Content", :with => "Here's a movie by nerds, for nerds, and about nerds."

    attach_file("article_image", File.expand_path("spec/fixtures/files/test.png"))
    click_on "Save"

    click_on "Computer Chess"

    expect(page).to have_css("img[src$='test.png']")
  end

  it "can be done when editing" do
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

    attach_file("article_image", File.expand_path("spec/fixtures/files/test.png"))
    click_on "Save"

    expect(page).to have_css("img[src$='test.png']")
  end
end
