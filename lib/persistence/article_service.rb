module Persistence
  class ArticleService
    include Pharrell::Constructor

    constructor Persistence::Database

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
      dataset.reverse_order(:published).all.map { |hash| Model.new(hash) }
    end

    def fetch_all_from_category(id)
      dataset.reverse_order(:published).where(:category_id => id).all.map { |hash| Model.new(hash) }
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

    def publish(id, time)
      @db[:articles].where(:id => id).update(:published => time)
    end

    def unpublish(id)
      @db[:articles].where(:id => id).update(:published => nil)
    end

    private

    def dataset
      if @published
        @db[:articles].where("published IS NOT NULL")
      else
        @db[:articles]
      end
    end
  end
end
