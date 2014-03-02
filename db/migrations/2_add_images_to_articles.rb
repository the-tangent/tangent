Sequel.migration do
  up do
    add_column :articles, :image_url, String
  end

  down do
    drop_column :articles, :image_url
  end
end
