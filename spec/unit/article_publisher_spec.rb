require "spec_helper"

describe Domain::ArticlePublisher do
  include Pharrell::Injectable
  injected :service, Persistence::ArticleService

  describe "#publish" do
    it "returns an error if the title is blank" do
      id = service.create("author", "", "film", "summary", "content", "image.png")
      publisher = Domain::ArticlePublisher.new(id, service)

      result = publisher.publish(Time.at(0))
      expect(result.error).to_not be_nil
    end

    it "returns an error if the author is blank" do
      id = service.create("", "title", "film", "summary", "content", "image.png")
      publisher = Domain::ArticlePublisher.new(id, service)

      result = publisher.publish(Time.at(0))
      expect(result.error).to_not be_nil
    end

    it "returns an error if the category is blank" do
      id = service.create("author", "title", "", "summary", "content", "image.png")
      publisher = Domain::ArticlePublisher.new(id, service)

      result = publisher.publish(Time.at(0))
      expect(result.error).to_not be_nil
    end

    it "returns an error if the category is bogus" do
      id = service.create("author", "title", "bogus", "summary", "content", "image.png")
      publisher = Domain::ArticlePublisher.new(id, service)

      result = publisher.publish(Time.at(0))
      expect(result.error).to_not be_nil
    end

    it "returns an error if the summary is blank" do
      id = service.create("author", "title", "film", "", "content", "image.png")
      publisher = Domain::ArticlePublisher.new(id, service)

      result = publisher.publish(Time.at(0))
      expect(result.error).to_not be_nil
    end

    it "returns an error if the content is blank" do
      id = service.create("author", "title", "film", "summary", "", "image.png")
      publisher = Domain::ArticlePublisher.new(id, service)

      result = publisher.publish(Time.at(0))
      expect(result.error).to_not be_nil
    end
  end
end
