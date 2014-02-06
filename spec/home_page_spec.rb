require "spec_helper"

describe "Homepage" do
  include Capybara::DSL

  before do
    Capybara.app = Sinatra::Application.new
  end

  it "shows an alluring message" do
    visit '/'
    expect(page).to have_content("We're not going to pay you...")
  end
end