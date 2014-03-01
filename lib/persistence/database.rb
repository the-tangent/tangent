module Persistence
  class Database
    def initialize(db_url)
      @db_url = db_url
    end

    def connect
      Sequel.connect(@db_url)
    end
  end
end
