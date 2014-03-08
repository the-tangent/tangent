ENV["RACK_ENV"] = "test"

require_relative 'support/fake_clock'
require_relative '../tangent'
require 'capybara'
require 'capybara/dsl'
require 'rspec'
require 'pharrell'

RSpec.configure do |config|
  config.around(:each) do |example|
    Pharrell.instance_for(Persistence::Database).transaction(:rollback=>:always){example.run}
  end
end
