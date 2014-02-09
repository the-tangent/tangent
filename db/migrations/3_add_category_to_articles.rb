Sequel.migration do
  up do
    add_column :articles, :category_id, Integer
  end

  down do
    drop_column :articles, :category_id
  end
end

