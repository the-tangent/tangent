require 'sinatra'
require 'sequel'

Sequel.connect(ENV["DATABASE_URL"] || "sqlite://tangent.db")

get '/' do
  "We're not going to pay you..."
end