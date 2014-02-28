Sequel.migration do
  up do
    drop_table :categories
    drop_column :articles, :category_id
    add_column :articles, :category_id, String
  end

  down do
    raise "Non reversible! Your data is screwed!"
  end
end
