module Persistence
  class Database
    def initialize(rack_env, database_url)
      @rack_env = rack_env
      @database_url = database_url
    end
    
    def connect
      Sequel.connect(db_url)
    end
    
    private
    
    def db_url 
      case @rack_env
        when "test"
          "sqlite://db/tangent-test.db"
        when "development"
          "sqlite://db/tangent.db"
        when "production"
          @database_url
      end
    end
  end
end