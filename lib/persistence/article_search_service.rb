module Persistence
  class ArticleSearchService
    include Pharrell::Constructor

    constructor Persistence::Database

    def initialize(db)
      @db = db
    end

    def search(query)
      query = query.downcase
      results = @db[:articles].where(Sequel.ilike(:title, "%#{query}%"))
      results.map { |r| Model.new(r) }
    end
  end
end
