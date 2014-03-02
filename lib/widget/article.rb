module Widget
  class Article
    attr_reader :id, :title, :author, :image_url

    def initialize(article)
      @id = article.id
      @title = article.title
      @author = article.author
      @content = article.content || ""
      @published = article.published
      @image_url = article.image_url
    end

    def content
      markdown_renderer = ::Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      markdown_renderer.render(@content)
    end

    def date
      @published.strftime("%e %B %Y")
    end

    def published?
      !!@published
    end
  end
end
