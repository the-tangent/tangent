Sequel.migration do
  up do
    create_table(:articles) do
      primary_key :id
      String :author
      String :title
      String :category_id
      String :content, :text => true
      Time :published
    end
  end

  down do
    drop_table(:articles)
  end
end
