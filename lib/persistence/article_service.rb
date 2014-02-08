class ArticleService
  def initialize(db)
    @db = db
  end
  
  def fetch(id)
    article = @db[:articles].where(:id => id).first
    article[:category] = @db[:categories].where(:id => article[:category_id]).first[:name]
    article
  end
  
  def fetch_all
    @db[:articles].all
  end
  
  def fetch_all_from_category(id)
    @db[:articles].where(:category_id => id).all
  end
  
  def create(author, title, category, content)
    @db[:articles].insert(
      :author => author,
      :title => title,
      :category_id => category,
      :content => content
    )
  end
  
  def update(id, author, title, category, content)
    @db[:articles].where(:id => id).update(
      :author => author,
      :title => title,
      :category_id => category,
      :content => content
    )
  end
end