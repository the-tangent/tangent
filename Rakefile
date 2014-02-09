require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)
task :default => :spec

namespace :db do
  task :migrate do
    `sequel -m db/migrations sqlite://db/tangent.db`
    `sequel -m db/migrations sqlite://db/tangent-test.db`
  end
end