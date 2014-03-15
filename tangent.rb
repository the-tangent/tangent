require "sinatra/base"
require "sinatra/nedry"

require "sequel"
require "redcarpet"
require 'redcarpet/render_strip'
require "pharrell"

require "fog"

require "./lib/all"
require "./config/pharrell"

require "./app/monitoring"
require "./app/base"
require "./app/editor"
require "./app/reader"
require "./app/feeds"

class Tangent < Sinatra::Base
  use Monitoring
  use Editor
  use Reader
  use Feeds
end
