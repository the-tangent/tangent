module Widget
  class Article
    attr_reader :id, :title, :author
    
    def initialize(article)
      @id = article[:id]
      @title = article[:title]
      @author = article[:author]
      @content = article[:content]
    end
    
    def content
      markdown_renderer = ::Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      markdown_renderer.render(@content)
    end
  end
end