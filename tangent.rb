require "sinatra/base"
require "./extensions/sinatra/nedry"

require "sequel"
require "redcarpet"
require "pharrell"

require "./lib/all"
require "./config"

require "./app/base"
require "./app/editor"
require "./app/reader"

class Tangent < Sinatra::Base
  use Reader
  use Editor
end