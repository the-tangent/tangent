ENV["RACK_ENV"] = "test"

require_relative '../tangent'
require 'capybara'
require 'capybara/dsl'
require 'rspec'
require 'pharrell'

Pharrell.config(:test, :extends => :base) do |config|
end

Pharrell.use_config(:test)

RSpec.configure do |config|
  config.around(:each) do |example|
    Pharrell.instance_for(Persistence::Database).transaction(:rollback=>:always){example.run}
  end
end
