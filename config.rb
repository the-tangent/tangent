Pharrell.config(:base) do |config|
  config.bind(System::Clock, System::Clock.new)
end

Pharrell.use_config(:base)

DB = Persistence::Database.new(ENV["RACK_ENV"], ENV["DATABASE_URL"]).connect