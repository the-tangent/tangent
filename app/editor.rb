class Editor < Base
  helpers Sinatra::Nedry

  injected :clock, System::Clock
  injected :article_service, Persistence::ArticleService
  injected :article_image_service, Persistence::ArticleImageService

  before do
    if ENV["RACK_ENV"] == "production"
      # Redirect to heroku/https for editor
      if request.path.start_with?("/editor") && request.scheme == "http"
        redirect to("https://#{ENV["HOSTNAME"]}#{request.path}")

      # Redirect to domain/http for anything else
      elsif !request.path.start_with?("/editor") && request.scheme == "https"
        redirect to("http://#{ENV["DOMAIN"]}#{request.path}")
      end
    end
  end

  get '/editor/?' do
    protected! do
      render_page :editor
    end
  end

  get '/editor/articles/?' do
    protected! do
      articles = published_service(params[:published]).fetch_all
      render_page :editor_articles, {
        :articles => articles,
        :published => params[:published] == "true",
      }
    end
  end

  get '/editor/articles/new/?' do
    protected! do
      render_page :editor_articles_new, :categories => Categories::ALL
    end
  end

  get '/editor/articles/:id/?' do
    protected! do
      article = article_service.fetch(params[:id])
      widget = Widget::Article.new(article)

      render_page :editor_articles_show, :article => widget
    end
  end

  get '/editor/articles/:id/edit/?' do
    protected! do
      article = article_service.fetch(params[:id])
      render_page :editor_articles_edit, :article => article, :categories => Categories::ALL
    end
  end

  post "/editor/articles/?" do
    protected! do
      article_params = params[:article]

      article_id = article_service.create(
        article_params[:author],
        article_params[:title],
        article_params[:category],
        article_params[:content]
      )

      image_url = if article_params[:image]
        article_image_service.upload(article_id, article_params[:image])
      else
        nil
      end

      article_service.update(article_id,
        article_params[:author],
        article_params[:title],
        article_params[:category],
        article_params[:content],
        image_url
      )

      redirect to("/editor/articles/#{article_id}")
    end
  end

  put "/editor/articles/:id/?" do
    protected! do
      article_params = params[:article]

      image_url = if article_params[:image]
        article_image_service.upload(params[:id], article_params[:image])
      else
        nil
      end

      article_service.update(params[:id],
        article_params[:author],
        article_params[:title],
        article_params[:category],
        article_params[:content],
        image_url
      )

      redirect to("/editor/articles/#{params[:id]}")
    end
  end

  delete "/editor/articles/:id/?" do
    protected! do
      article_service.delete(params[:id])
      redirect to("/editor/articles")
    end
  end

  post "/editor/articles/:id/publishing/?" do
    protected! do
      publisher = Domain::ArticlePublisher.new(params[:id], article_service)
      article = publisher.publish(clock.now)

      if article.error
        render_page :editor_articles_edit, :article => article, :categories => Categories::ALL
      else
        redirect to("/editor/articles/#{params[:id]}")
      end
    end
  end

  delete "/editor/articles/:id/publishing/?" do
    protected! do
      article_service.unpublish(params[:id])
      redirect to("/editor/articles/#{params[:id]}")
    end
  end

  get "/editor/categories/?" do
    protected! do
      render_page :editor_categories, :categories => Categories::ALL
    end
  end

  get "/editor/categories/:id/?" do
    protected! do
      category = Categories.fetch(params[:id])
      articles = published_service(params[:published]).fetch_all_from_category(category.id)
      render_page :editor_categories_show, {
        :category => category,
        :published => params[:published] == "true",
        :articles => articles
      }
    end
  end

  private

  def render_page(template, locals = {})
    locals = locals.merge(:date => clock.now, :categories => Categories::ALL)
    erb(template, :locals => locals, :layout => :editor_layout)
  end

  def published_service(published)
    if published == "true"
      article_service.published
    else
      article_service.unpublished
    end
  end
end
