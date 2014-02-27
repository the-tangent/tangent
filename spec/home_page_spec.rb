require "spec_helper"
require "pry"

describe "Homepage" do
  include Capybara::DSL
  include Pharrell::Injectable

  injected :article_service, Persistence::ArticleService
  injected :category_service, Persistence::CategoryService

  before do
    Capybara.app = Tangent.new
  end

  it "lists articles with summaries" do
    article_service.publish(article_service.create(
      "Roger Ebert",
      "Computer Chess",
      nil,
      "A good film\r\n\r\nAnother thing"
    ))

    article_service.publish(article_service.create(
      "Heather Long",
      "Dylan Farrow Is Already Too Old",
      nil,
      "Oh my god Woody Allen\r\n\r\nAnother thing"
    ))

    visit '/'

    expect(page).to have_content("Computer Chess")
    expect(page).to have_content("A good film")

    expect(page).to have_content("Dylan Farrow Is Already Too Old")
    expect(page).to have_content("Oh my god Woody Allen")

    expect(page).to have_no_content("Another thing")
  end

  describe "clicking on an article" do
    it "shows the article's content" do
      article_service.publish(article_service.create(
        "Roger Ebert",
        "Computer Chess",
        nil,
        "The *best*:\n\nMovie."
      ))

      visit '/'
      click_on "Computer Chess"

      expect(page.html).to include("<p>The <em>best</em>:</p>")
      expect(page.html).to include("<p>Movie.</p>")
    end
  end

  describe "clicking on a category" do
    it "shows articles for that category" do
      article_service.publish(article_service.create(
        "Roger Ebert",
        "Computer Chess",
        category_service.create("Film"),
        "some content"
      ))

      article_service.publish(article_service.create(
        "Heather Long",
        "Other Category Article",
        category_service.create("Other"),
        "some content"
      ))

      visit '/'
      click_on "Film"
      expect(page).to have_content("Computer Chess")
      expect(page).to have_no_content("Other Category Article")
    end
  end
end
