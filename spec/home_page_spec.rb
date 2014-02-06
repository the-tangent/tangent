ENV["RACK_ENV"] = "test"

require_relative '../app'
require 'capybara'
require 'capybara/dsl'
require 'rspec'

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