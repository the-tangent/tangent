require "spec_helper"

describe Persistence::ArticleSearchService do
  let(:db) { Pharrell.instance_for(Persistence::Database) }
  let(:service) { Persistence::ArticleSearchService.new(db) }

  describe "#search" do
    it "returns articles that have exact matching titles" do
      db[:articles].insert(:title => "some words")
      db[:articles].insert(:title => "other thing")

      results = service.search("some words")
      expect(results.length).to eq(1)
      expect(results.first.title).to eq("some words")
    end

    it "returns articles that have matching title words" do
      db[:articles].insert(:title => "some words")
      db[:articles].insert(:title => "other thing")

      results = service.search("words")
      expect(results.length).to eq(1)
      expect(results.first.title).to eq("some words")
    end

    it "return articles that have matching substrings" do
      db[:articles].insert(:title => "some words")
      db[:articles].insert(:title => "other thing")

      results = service.search("wor")
      expect(results.length).to eq(1)
      expect(results.first.title).to eq("some words")
    end

    it "searches case insensitively" do
      db[:articles].insert(:title => "some words")
      db[:articles].insert(:title => "Other Thing")

      results = service.search("WORD")
      expect(results.length).to eq(1)
      expect(results.first.title).to eq("some words")

      results = service.search("Other")
      expect(results.length).to eq(1)
      expect(results.first.title).to eq("Other Thing")
    end

    it "returns all for a blank query" do
      db[:articles].insert(:title => "some words")
      db[:articles].insert(:title => "Other Thing")

      results = service.search("")
      expect(results.length).to eq(2)
    end
  end
end
