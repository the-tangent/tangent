require "sinatra/base"
require "sinatra/nedry"

require "sequel"
require "redcarpet"
require "pharrell"

require "./lib/all"
require "./config"

require "./app/monitoring"
require "./app/base"
require "./app/editor"
require "./app/manifesto"
require "./app/reader"

class Tangent < Sinatra::Base
  use Monitoring
  use Editor
  use Manifesto if ENV["RACK_ENV"] == "production"
  use Reader
end
