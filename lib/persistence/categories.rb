class Categories
  class Category
    attr_reader :id, :name

    def initialize(id, name)
      @id = id
      @name = name
    end
  end

  ALL = [
    HEREANDNOW = Category.new("hereandnow", "Here & Now"),
    LIFE = Category.new("life", "Life"),
    ART = Category.new("art", "Art"),
    SCIENCE = Category.new("science", "Science"),
    FILM = Category.new("film", "Film"),
    THEATRE = Category.new("theatre", "Theatre")
  ]

  def self.fetch(id)
    ALL.select { |c| c.id == id }.first
  end
end
