ENV["RACK_ENV"] = "test"

require_relative '../app'
require 'capybara'
require 'capybara/dsl'
require 'rspec'

RSpec.configure do |config|
  config.around(:each) do |example|
    DB.transaction(:rollback=>:always){example.run}
  end
end