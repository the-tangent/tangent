require_relative "../lib/persistence/database"
require_relative "../lib/persistence/article_service"

describe Persistence::ArticleService do
  let(:service) { Persistence::ArticleService.new(DB) }

  describe "#publish" do
    it "publishes the article the passed id" do
      ids = service.create("", "", nil, ""), service.create("", "", nil, "")

      time = Time.now
      service.publish(ids[0], time)

      expect(service.fetch(ids[0]).published).to eq(time)
      expect(service.fetch(ids[1]).published).to be_nil
    end
  end

  describe "#unpublish" do
    it "unpublishes the article the passed id" do
      ids = service.create("", "", nil, ""), service.create("", "", nil, "")

      time = Time.now
      service.publish(ids[0], time)
      service.publish(ids[1], time)

      service.unpublish(ids[0])

      expect(service.fetch(ids[0]).published).to be_nil
      expect(service.fetch(ids[1]).published).to eq(time)
    end
  end
end
