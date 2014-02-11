DB = Persistence::Database.new(ENV["RACK_ENV"], ENV["DATABASE_URL"]).connect

Pharrell.config(:base) do |config|
  config.bind(System::Clock, System::Clock.new)
  config.bind(Persistence::ArticleService, Persistence::ArticleService.new(DB))
  config.bind(Persistence::CategoryService, Persistence::CategoryService.new(DB))
end

Pharrell.use_config(:base)