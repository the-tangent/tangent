class Monitoring < Sinatra::Base
  configure :production do
    require 'newrelic_rpm'
  end
  
  get "/ping" do
    "pong"
  end
end