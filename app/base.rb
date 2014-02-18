class Base < Sinatra::Base
  enable :method_override, :logging
  set :public_folder, 'public'
  
  include Pharrell::Injectable
  injected :article_service, Persistence::ArticleService
  injected :category_service, Persistence::CategoryService
  
  def not_authorized
    headers['WWW-Authenticate'] = 'Basic realm="Restricted Area"'
    halt 401, erb(:not_authorized)
  end
end