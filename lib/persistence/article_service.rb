class ArticleService
  def initialize(db)
    @db = db
  end
  
  def fetch(id)
    @db[:articles].where(:id => id).first
  end
  
  def fetch_all
    @db[:articles].all
  end
  
  def create(author, title, content)
    @db[:articles].insert(
      :author => author,
      :title => title,
      :content => content
    )
  end
end