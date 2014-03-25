Sequel.migration do
  up do
    add_column :articles, :summary, String
  end

  down do
    drop_column :articles, :summary
  end
end
