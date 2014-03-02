require "spec_helper"

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
      "The *best*:\n\nMovie.",
      "http://someimagehost.com/test.png"
    )

    time = Time.parse("4 February 2014")
    article_service.publish(article_id, time)

    visit "/"
    click_on "Computer Chess"

    expect(page).to have_content("Computer Chess")
    expect(page).to have_content("Roger Ebert")
    expect(page).to have_content("4 February 2014")
    expect(page).to have_css("img[src='http://someimagehost.com/test.png']")

    expect(page.html).to include("<p>The <em>best</em>:</p>")
    expect(page.html).to include("<p>Movie.</p>")
  end
end
