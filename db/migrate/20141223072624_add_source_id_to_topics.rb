class AddSourceIdToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :source_id, :integer, null: false
    add_index :topics, [:source_id, :name], unique: true
  end
end
