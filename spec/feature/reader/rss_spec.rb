require "spec_helper"

describe "Article RSS feed" do
  include Capybara::DSL
  include Pharrell::Injectable

  before do
    Capybara.app = Tangent.new
  end

  it "is available" do
    visit "/rss.xml"
    expect(page.body).to include("<title>The Tangent</title>")
  end
end
