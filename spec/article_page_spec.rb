require "spec_helper"
require "pry"

describe "Article page" do
  include Capybara::DSL
  include Pharrell::Injectable

  injected :article_service, Persistence::ArticleService

  before do
    Capybara.app = Tangent.new
  end

  it "shows the article" do
    article_id = article_service.create(
      "Roger Ebert",
      "Computer Chess",
      nil,
      "The *best*:\n\nMovie."
    )

    article_service.publish(article_id, Time.now)

    visit "/articles/#{article_id}"

    expect(page).to have_content("Computer Chess")
    expect(page).to have_content("Roger Ebert")

    expect(page.html).to include("<p>The <em>best</em>:</p>")
    expect(page.html).to include("<p>Movie.</p>")
  end
end
