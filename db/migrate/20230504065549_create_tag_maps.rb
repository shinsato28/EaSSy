class CreateTagMaps < ActiveRecord::Migration[6.1]
  def change
    create_table :tag_maps do |t|
      t.integer :novel_id
      t.integer :tag_id

      t.timestamps
    end
  end
end
