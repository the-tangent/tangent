xml.instruct! :xml, :version => '1.0'
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The Tangent"
    xml.description "Latest articles from The Tangent."
    xml.link "http://www.thetangent.org.uk"

    @articles.each do |article|
      xml.item do
        xml.title article.title
        xml.link article.url
        
        xml.description {
          xml.cdata!(article.description)
        }

        xml.pubDate article.published_date
        xml.guid article.url
      end
    end
  end
end
