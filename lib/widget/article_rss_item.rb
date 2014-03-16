module Widget
  class ArticleRssItem
    attr_reader :id, :title

    def initialize(article)
      @id = article.id
      @title = article.title
      @content = article.content
      @published = article.published
    end

    def description
      markdown_renderer = ::Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      markdown_renderer.render(@content)
    end

    def published_date
      @published.rfc822
    end

    def url
      "http://#{ENV["DOMAIN"]}/articles/#{@id}"
    end
  end
end
