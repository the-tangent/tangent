ENV["RACK_ENV"] = "test"

require_relative '../app'
require 'capybara'
require 'capybara/dsl'
require 'rspec'