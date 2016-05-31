class ChangeNameFormatInMappedTerms < ActiveRecord::Migration
  def up
    remove_index :mapped_terms, name: :index_mapped_terms_on_source_id_and_name
    change_column :mapped_terms, :name, :text
  end

  def down
    change_column :mapped_terms, :name, :string
    add_index :mapped_terms, name: :index_mapped_terms_on_source_id_and_name
  end
end
