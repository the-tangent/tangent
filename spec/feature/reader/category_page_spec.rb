require "spec_helper"

describe "Homepage" do
  include Capybara::DSL
  include Pharrell::Injectable

  injected :article_service, Persistence::ArticleService
  injected :clock, System::Clock

  before do
    Capybara.app = Tangent.new
  end

  it "links to the home page" do
    article_service.publish(article_service.create(
      "Roger Ebert",
      "Computer Chess",
      Categories::FILM.id,
      "summary",
      "some content"
    ), Time.at(0))

    article_service.publish(article_service.create(
      "Heather Long",
      "Other Category Article",
      Categories::LIFE.id,
      "summary",
      "some content"
    ), Time.at(0))

    visit '/'
    click_on "Film"

    click_on "Home"
    expect(page).to have_content("Computer Chess")
    expect(page).to have_content("Other Category Article")
  end
end
