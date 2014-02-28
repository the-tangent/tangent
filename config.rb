DB = Persistence::Database.new(ENV["RACK_ENV"], ENV["DATABASE_URL"]).connect

Pharrell.config(:base) do |config|
  config.bind(Persistence::ArticleService, Persistence::ArticleService.new(DB))
end

Pharrell.use_config(:base)
