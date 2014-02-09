ENV["RACK_ENV"] = "test"

require_relative '../app'
require_relative "support/fake_clock"
require 'capybara'
require 'capybara/dsl'
require 'rspec'
require 'pharrell'

Pharrell.config(:test) do |config|
  config.bind(System::Clock, FakeClock.new)
end

Pharrell.use_config(:test)

RSpec.configure do |config|
  config.around(:each) do |example|
    DB.transaction(:rollback=>:always){example.run}
  end
end