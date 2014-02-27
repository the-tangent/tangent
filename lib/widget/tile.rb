module Widget
  class Tile
    attr_reader :id, :title, :author
    
    def initialize(article)
      @id = article.id
      @title = article.title
      @content = article.content || ""
    end
    
    def summary
      first_para = @content.split("\r\n\r\n").first
      markdown_renderer = ::Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      markdown_renderer.render(first_para || "")
    end
  end
end