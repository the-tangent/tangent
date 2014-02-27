module Persistence
  class ArticleService
    def initialize(db, published: false)
      @db = db
      @published = published
    end

    def published
      self.class.new(@db, :published => true)
    end

    def fetch(id)
      Model.new(dataset.where(:id => id).first)
    end

    def fetch_all
      dataset.all.map { |hash| Model.new(hash) }
    end

    def fetch_all_from_category(id)
      dataset.where(:category_id => id).all.map { |hash| Model.new(hash) }
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

    private

    def dataset
      if @published
        @db[:articles].where(:published => true)
      else
        @db[:articles]
      end
    end
  end
end
