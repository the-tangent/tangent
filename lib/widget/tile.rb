module Widget
  class Tile
    attr_reader :id, :title, :author

    def initialize(article)
      @id = article.id
      @title = article.title
      @content = article.content || ""
    end

    def summary
      first_para = @content.split(/\r?\n\r?\n/).first
      markdown_renderer = ::Redcarpet::Markdown.new(Redcarpet::Render::StripDown)
      markdown_renderer.render(first_para || "").chomp
    end
  end
end
