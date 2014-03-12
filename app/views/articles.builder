xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The Tangent"
    xml.description "Latest articles from The Tangent."
    xml.link "http://www.thetangent.org.uk"

    @articles.each do |article|
      xml.item do
        xml.title article.title
        xml.link "http://www.thetangent.org.uk/articles/#{article.id}"
        xml.description article.content
        xml.pubDate article.published.rfc822
        xml.guid "http://www.thetangent.org.uk/articles/#{article.id}"
      end
    end
  end
end
