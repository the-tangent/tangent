if ENV["RACK_ENV"] != "production"
  Fog.mock!

  FOG = Fog::Storage.new(
    :provider => "AWS",
    :aws_access_key_id => "",
    :aws_secret_access_key => ""
  )

  FOG.directories.create(
    :key    => "the-tangent",
    :public => true
  )
else
  FOG = Fog::Storage.new(
    :provider => "AWS",
    :aws_access_key_id => ENV["S3_ACCESS_KEY"],
    :aws_secret_access_key => ENV["S3_SECRET_KEY"]
  )
end

Pharrell.config(:base) do |config|
  config.bind(System::Clock, System::Clock.new)
  config.bind(Persistence::ArticleService, Persistence::ArticleService)

  directory = FOG.directories.select { |d| d.key == "the-tangent" }.first
  config.bind(Fog::Storage::AWS::Directory, directory)
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
