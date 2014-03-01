db = Persistence::Database.new(ENV["RACK_ENV"], ENV["DATABASE_URL"]).connect

Pharrell.config(:base) do |config|
  config.bind(Persistence::Database, db)
  config.bind(System::Clock, System::Clock.new)

  config.bind(Persistence::ArticleService, Persistence::ArticleService)
end

Pharrell.use_config(:base)
