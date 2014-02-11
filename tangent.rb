require "sinatra/base"

require "sequel"
require "redcarpet"
require "pharrell"

require "./lib/all"
require "./config"

require "./app/base"
require "./app/editor"
require "./app/reader"

class Tangent < Reader
end