require "spec_helper"

describe "Homepage" do
  include Capybara::DSL
  include Pharrell::Injectable

  injected :article_service, Persistence::ArticleService
  injected :clock, System::Clock

  before do
    Capybara.app = Tangent.new
  end

  it "shows the current date" do
    clock.set_time("19/01/2014")

    visit "/"
    expect(page).to have_content("19 January 2014")
  end

  it "lists articles with summaries" do
    article_service.publish(article_service.create(
      "Roger Ebert",
      "Computer Chess",
      Categories::FILM.id,
      "A good film\r\n\r\nAnother thing"
    ), Time.at(0))

    article_service.publish(article_service.create(
      "Heather Long",
      "Dylan Farrow Is Already Too Old",
      Categories::FILM.id,
      "Oh my god Woody Allen\r\n\r\nAnother thing"
    ), Time.at(0))

    visit '/'

    expect(page).to have_content("Computer Chess")
    expect(page).to have_content("A good film")

    expect(page).to have_content("Dylan Farrow Is Already Too Old")
    expect(page).to have_content("Oh my god Woody Allen")

    expect(page).to have_no_content("Another thing")
  end

  it "links to the categories" do
    visit "/"
    expect(page).to have_link("Here/Now")
    expect(page).to have_link("Life")
    expect(page).to have_link("Art")
    expect(page).to have_link("Film")
    expect(page).to have_link("Theatre")
    expect(page).to have_link("Science")
  end

  describe "clicking on a category" do
    it "shows articles for that category" do
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
      click_on "Film"
      expect(page).to have_content("Computer Chess")
      expect(page).to have_no_content("Other Category Article")
    end
  end
end
