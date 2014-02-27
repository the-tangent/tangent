require_relative "../lib/persistence/database"
require_relative "../lib/persistence/article_service"

describe Persistence::ArticleService do
  include Pharrell::Injectable

  injected :service, Persistence::ArticleService

  describe "#publish" do
    it "publishes the article the passed id" do
      ids = service.create("", "", nil, ""), service.create("", "", nil, "")

      service.publish(ids[0])

      expect(service.fetch(ids[0]).published).to be_true
      expect(service.fetch(ids[1]).published).to be_false
    end
  end

  describe "#unpublish" do
    it "unpublishes the article the passed id" do
      ids = service.create("", "", nil, ""), service.create("", "", nil, "")
      service.publish(ids[0])
      service.publish(ids[1])

      service.unpublish(ids[0])

      expect(service.fetch(ids[0]).published).to be_false
      expect(service.fetch(ids[1]).published).to be_true
    end
  end
end
