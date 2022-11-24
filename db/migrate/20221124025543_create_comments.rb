class CreateComments < ActiveRecord::Migration[6.1]
  def change
    create_table :comments do |t|
      t.references :tournament, foreign_key: true, null: false
      t.references :user, foreign_key: true, null: false
      t.references :parent, foreign_key: { to_table: 'comments' }, null: true
      t.text :body

      t.timestamps
    end
  end
end
