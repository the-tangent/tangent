module Persistence  
  class ArticleService
    def initialize(db)
      @db = db
    end
  
    def fetch(id)
      Model.new(@db[:articles].where(:id => id).first)
    end
  
    def fetch_all
      @db[:articles].all.map { |hash| Model.new(hash) }
    end
  
    def fetch_all_from_category(id)
      @db[:articles].where(:category_id => id).all.map { |hash| Model.new(hash) }
    end
  
    def create(author, title, category, content)
      @db[:articles].insert(
        :author => author,
        :title => title,
        :category_id => category,
        :content => content
      )
    end
  
    def update(id, author, title, category, content)
      @db[:articles].where(:id => id).update(
        :author => author,
        :title => title,
        :category_id => category,
        :content => content
      )
    end
    
    def publish(id)
      @db[:articles].where(:id => id).update(:published => true)
    end
    
    def unpublish(id)
      @db[:articles].where(:id => id).update(:published => false)
    end
  end
end