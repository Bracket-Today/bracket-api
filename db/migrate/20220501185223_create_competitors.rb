class CreateCompetitors < ActiveRecord::Migration[6.1]
  def change
    create_table :competitors do |t|
      t.references :tournament, foreign_key: { on_delete: :cascade },
        null: false
      t.references :entity, foreign_key: true, null: false
      t.integer :seed

      t.timestamps
    end
  end
end
