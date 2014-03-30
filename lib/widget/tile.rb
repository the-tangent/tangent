module Widget
  class Tile
    attr_reader :id, :title, :author, :summary, :image_url

    def initialize(article)
      @id = article.id
      @title = article.title
      @summary = article.summary
      @image_url = article.image_url
    end
  end
end
