Sequel.migration do
  up do
    drop_column :articles, :published
    add_column :articles, :published, Time
  end

  down do
    raise "Non reversible! Your data is screwed!"
  end
end
