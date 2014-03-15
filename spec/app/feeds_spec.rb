require "spec_helper"
require "pry"

describe Feeds do
  include Rack::Test::Methods

  include Pharrell::Injectable
  injected :article_service, Persistence::ArticleService

  def app
    Feeds
  end

  describe "GET /rss.xml" do
    it "returns the last 20 published articles" do
      ids = 20.times.map do |i|
        article_id = article_service.create("", "title#{i}", "film", "*content#{i}*")
        article_service.publish(article_id, Time.at(i))
        article_id
      end

      article_service.create("", "title20", "film", "content20")

      get "/rss.xml"

      xml = Nokogiri::XML(last_response.body)
      expect(xml.root.name).to eq("rss")

      channel = xml.root.children.select { |e| e.name =="channel" }.first
      title = channel.children.select { |e| e.name == "title" }.first
      expect(title.text).to eq("The Tangent")

      description = channel.children.select { |e| e.name =="description" }.first
      expect(description.text).to eq("Latest articles from The Tangent.")

      link = channel.children.select { |e| e.name =="link" }.first
      expect(link.text).to eq("http://www.thetangent.org.uk")

      articles = channel.children.select { |e| e.name == "item" }
      expect(articles.length).to eq(20)

      article = articles.first.children

      title = article.select { |e| e.name == "title" }.first
      expect(title.text).to eq("title19")

      description = article.select { |e| e.name == "description" }.first
      expect(description.text).to eq("content19")

      link = article.select { |e| e.name == "link" }.first
      expect(link.text).to eq("http://test.example.com/articles/#{ids.last}")

      pub_date = article.select { |e| e.name == "pubDate" }.first
      expect(Time.parse(pub_date.text)).to eq(Time.at(19))

      guid = article.select { |e| e.name == "guid" }.first
      expect(guid.text).to eq("http://test.example.com/articles/#{ids.last}")
    end
  end
end
