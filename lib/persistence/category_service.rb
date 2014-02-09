module Persistence  
  class CategoryService
    def initialize(db)
      @db = db
    end
  
    def fetch(id)
      Model.new(@db[:categories].where(:id => id).first)
    end
  
    def fetch_all
      DB[:categories].all.map { |hash| Model.new(hash) }
    end
  
    def create(name)
      @db[:categories].insert(:name => name)
    end
  
    def update(id, name)
      @db[:categories].where(:id => id).update(:name => name)
    end
  end
end