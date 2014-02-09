module Persistence  
  class CategoryService
    def initialize(db)
      @db = db
    end
  
    def fetch(id)
      Model.new(@db[:categories].where(:id => id).first)
    end
  
    def fetch_all(articles: nil)
      categories = DB[:categories].all.map { |hash| Model.new(hash) }
      
      if articles.nil?
        categories
      else
        attach_articles(categories, articles)
      end
    end
    
    def attach_articles(categories, article_service)
      categories_with_articles = categories.reduce([]) do |categories, category|
        articles = article_service.fetch_all_from_category(category.id)
    
        if articles.empty?
          categories
        else
          category_with_articles = {
            :id => category.id,
            :name => category.name,
            :articles => articles
          }
      
          categories << Model.new(category_with_articles)
        end
      end
    end
  
    def create(name)
      @db[:categories].insert(:name => name)
    end
  
    def update(id, name)
      @db[:categories].where(:id => id).update(:name => name)
    end
  end
end