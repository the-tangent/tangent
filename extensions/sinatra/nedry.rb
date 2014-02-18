module Sinatra
  module Nedry
    def protected!(&blk)
      if authorized?
        blk.call
      else
        not_authorized
      end
    end
    
    def flagged!(&blk)
      if authorized? || ENV["RACK_ENV"] != "production"
        blk.call
      else
        not_authorized
      end
    end
    
    private
    
    def authorized?
      admin_credentials = if ENV["RACK_ENV"] == "production"
        [ENV["ADMIN_USERNAME"], ENV["ADMIN_PASSWORD"]]
      else
        ["admin", "admin"]
      end      
  
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == editor_credentials
    end
  end

  helpers Nedry
end
