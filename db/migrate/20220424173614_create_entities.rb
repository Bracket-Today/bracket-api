class CreateEntities < ActiveRecord::Migration[6.1]
  def change
    create_table :entities do |t|
      t.string :name, index: { length: 20 }, null: false
      t.string :path, index: { length: 20 }, null: false
      t.text :url

      t.timestamps
    end
  end
end
