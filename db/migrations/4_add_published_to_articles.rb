Sequel.migration do
  up do
    add_column :articles, :published, TrueClass
  end

  down do
    drop_column :articles, :published
  end
end

