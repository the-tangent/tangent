require "sinatra/base"
require "sinatra/nedry"

require "sequel"
require "redcarpet"
require "pharrell"

require "./lib/all"
require "./config"

require "./app/base"
require "./app/editor"
require "./app/reader"

class Tangent < Sinatra::Base
  configure :production do
    require 'newrelic_rpm'
  end
  
  use Editor
  use Reader
end