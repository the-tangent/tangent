module Persistence
  class ArticleService
    include Pharrell::Constructor

    constructor Persistence::Database

    def initialize(db, published: nil)
      @db = db
      @published = published
    end

    def published
      self.class.new(@db, :published => true)
    end

    def unpublished
      self.class.new(@db, :published => false)
    end

    def fetch(id)
      row = dataset.where(:id => id).first

      if row
        Model.new(row)
      else
        nil
      end
    end

    def fetch_all
      dataset.reverse_order(:published).all.map { |hash| Model.new(hash) }
    end

    def fetch_all_from_category(id)
      dataset.reverse_order(:published).where(:category_id => id).all.map { |hash| Model.new(hash) }
    end

    def create(author, title, category, content, image_url = nil)
      @db[:articles].insert(
        :author => author,
        :title => title,
        :category_id => category,
        :content => content,
        :image_url => image_url
      )
    end

    def update(id, author, title, category, content, image_url = nil)
      @db[:articles].where(:id => id).update(
        :author => author,
        :title => title,
        :category_id => category,
        :content => content,
        :image_url => image_url
      )
    end

    def delete(id)
      @db[:articles].where(:id => id).delete
    end

    def publish(id, time)
      @db[:articles].where(:id => id).update(:published => time)
    end

    def unpublish(id)
      @db[:articles].where(:id => id).update(:published => nil)
    end

    private

    def dataset
      if @published.nil?
        @db[:articles]
      elsif @published
        @db[:articles].where("published IS NOT NULL")
      else
        @db[:articles].where("published IS NULL")
      end
    end
  end
end
