module Widget
  class RssItem
    attr_reader :id, :title

    def initialize(article)
      @id = article.id
      @title = article.title
      @content = article.content
      @published = article.published
    end

    def description
      first_para = @content.split(/\r?\n\r?\n/).first
      markdown_renderer = ::Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
      markdown_renderer.render(first_para || "").chomp
    end

    def published_date
      @published.rfc822
    end

    def url
      "http://#{ENV["DOMAIN"]}/articles/#{@id}"
    end
  end
end
