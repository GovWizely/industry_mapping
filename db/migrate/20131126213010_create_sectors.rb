class CreateSectors < ActiveRecord::Migration
  def change
    create_table :sectors do |t|
      t.references :industry, index: true
      t.string :name
      t.string :protege_id
      t.timestamps
    end
  end
end
