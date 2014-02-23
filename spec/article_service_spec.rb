require_relative "../lib/persistence/database"
require_relative "../lib/persistence/article_service"

RSpec.configure do |config|
  config.around(:each) do |example|
    DB.transaction(:rollback=>:always){example.run}
  end
end

describe Persistence::ArticleService do
  let(:db) { Persistence::Database.new(ENV["RACK_ENV"], ENV["DATABASE_URL"]).connect }
  
  describe "#publish" do
    it "publishes the article the passed id" do
      service = Persistence::ArticleService.new(db)   
      ids = service.create("", "", nil, ""), service.create("", "", nil, "") 
      
      service.publish(ids[0])
      
      expect(service.fetch(ids[0]).published).to be_true
      expect(service.fetch(ids[1]).published).to be_false
    end
  end
  
  describe "#unpublish" do
    it "unpublishes the article the passed id" do
      service = Persistence::ArticleService.new(db)   
      ids = service.create("", "", nil, ""), service.create("", "", nil, "") 
      service.publish(ids[0])
      service.publish(ids[1])
      
      service.unpublish(ids[0])
      
      expect(service.fetch(ids[0]).published).to be_false
      expect(service.fetch(ids[1]).published).to be_true
    end
  end
end