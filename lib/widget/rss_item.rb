module Widget
  class RssItem
    attr_reader :id, :title

    def initialize(article)
      @id = article.id
      @title = article.title
      @content = article.content
      @published = article.published
    end

    def content
      markdown_renderer = ::Redcarpet::Markdown.new(Redcarpet::Render::HTML)
      html = markdown_renderer.render(@content)
      "<![CDATA[#{html.chomp}]]>"
    end

    def published
      @published.rfc822
    end

    def url
      "http://#{ENV["DOMAIN"]}/articles/#{@id}"
    end
  end
end
