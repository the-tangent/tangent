module Http
  class BasicAuth
    def initialize(request, rack_env, username, password)
      @request = request
      @rack_env = rack_env
      @username = username
      @password = password
    end
    
    def authorized?
      editor_credentials = if @rack_env == "production"
        [@username, @password]
      else
        ["editor", "editor"]
      end      
  
      @auth ||=  Rack::Auth::Basic::Request.new(@request.env)
      @auth.provided? and @auth.basic? and @auth.credentials and @auth.credentials == editor_credentials
    end
  end
end