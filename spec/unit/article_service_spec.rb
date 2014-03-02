require_relative "../../lib/persistence/database"
require_relative "../../lib/persistence/article_service"

describe Persistence::ArticleService do
  let(:db) { Pharrell.instance_for(Persistence::Database) }
  let(:service) { Persistence::ArticleService.new(db) }

  describe "#fetch" do
    it "returns nil if the id does not exist" do
      expect(service.fetch(0)).to eq(nil)
      expect(service.fetch("hello")).to eq(nil)
    end
  end

  describe "#fetch_all" do
    it "returns results in reverse date order" do
      ids = service.create("", "", nil, ""), service.create("", "", nil, ""), service.create("", "", nil, "")
      service.publish(ids[1], Time.at(0))
      service.publish(ids[0], Time.at(2))
      service.publish(ids[2], Time.at(1))

      expect(service.fetch_all.map(&:id)).to eq([ids[0], ids[2], ids[1]])
    end
  end

  describe "#fetch_all_from_category" do
    it "returns results in reverse date order" do
      ids = service.create("", "", "art", ""), service.create("", "", "art", ""), service.create("", "", "art", "")
      service.publish(ids[1], Time.at(0))
      service.publish(ids[0], Time.at(2))
      service.publish(ids[2], Time.at(1))

      expect(service.fetch_all_from_category("art").map(&:id)).to eq([ids[0], ids[2], ids[1]])
    end
  end

  describe "#publish" do
    it "publishes the article the passed id" do
      ids = service.create("", "", nil, ""), service.create("", "", nil, "")

      time = Time.at(0)
      service.publish(ids[0], time)

      expect(service.fetch(ids[0]).published).to eq(time)
      expect(service.fetch(ids[1]).published).to be_nil
    end
  end

  describe "#unpublish" do
    it "unpublishes the article the passed id" do
      ids = service.create("", "", nil, ""), service.create("", "", nil, "")

      time = Time.at(0)
      service.publish(ids[0], time)
      service.publish(ids[1], time)

      service.unpublish(ids[0])

      expect(service.fetch(ids[0]).published).to be_nil
      expect(service.fetch(ids[1]).published).to eq(time)
    end
  end
end
