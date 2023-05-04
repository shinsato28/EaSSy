class CreateNovels < ActiveRecord::Migration[6.1]
  def change
    create_table :novels do |t|
      t.integer :user_id
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :is_unpublished, default: false
      t.boolean :is_deleted, default: false

      t.timestamps
    end
  end
end
