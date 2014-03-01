Pharrell.config(:base) do |config|
  config.bind(System::Clock, System::Clock.new)
  config.bind(Persistence::ArticleService, Persistence::ArticleService)
end

Pharrell.config(:test, :extends => :base) do |config|
  db = Persistence::Database.new("sqlite://db/tangent-test.db").connect
  config.bind(Persistence::Database, db)
end

Pharrell.config(:development, :extends => :base) do |config|
  db = Persistence::Database.new("sqlite://db/tangent.db").connect
  config.bind(Persistence::Database, db)
end

Pharrell.config(:production, :extends => :base) do |config|
  db = Persistence::Database.new(ENV["DATABASE_URL"]).connect
  config.bind(Persistence::Database, db)
end

Pharrell.use_config(ENV["RACK_ENV"].to_sym)
