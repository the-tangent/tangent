module Domain
  class ArticlePublisher
    def initialize(id, service)
      @article_id = id
      @service = service
    end

    def publish(time)
      article = @service.fetch(@article_id)

      if article_ok?(article)
        @service.publish(@article_id, time)
        article
      else
        article.set(:error, "Article is not finished! Can't publish it yet.")
      end
    end

    private

    def article_ok?(article)
      [
        article.title && article.title.length > 0,
        article.author && article.author.length > 0,
        article.category_id && Categories::ALL.map(&:id).include?(article.category_id),
        article.content && article.content.length > 0
      ].all?
    end
  end
end
