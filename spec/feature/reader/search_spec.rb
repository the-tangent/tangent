require "spec_helper"

describe "Searching for articles" do
  include Capybara::DSL
  include Pharrell::Injectable

  injected :article_service, Persistence::ArticleService

  before do
    Capybara.app = Tangent.new
  end

  it "shows articles that have matching titles" do
    article_service.publish(article_service.create(
      "Roger Ebert",
      "Computer Chess",
      Categories::FILM.id,
      "some content"
    ), Time.at(0))

    article_service.publish(article_service.create(
      "Heather Long",
      "Other Category Article",
      Categories::LIFE.id,
      "some content"
    ), Time.at(0))

    visit '/'
    fill_in "Search", :with => "chess"
    click_button "search_submit"

    expect(page).to have_content("Computer Chess")
    expect(page).to have_no_content("Other Category Article")
    expect(page).to have_field("Search", :with => "chess")
  end

  context "when there are no matching articles" do
    it "shows a message" do
      visit "/"
      fill_in "Search", :with => "chess"
      click_button "search_submit"

      expect(page).to have_content("Couldn't find")
      expect(page).to have_content("chess")
    end
  end
end
