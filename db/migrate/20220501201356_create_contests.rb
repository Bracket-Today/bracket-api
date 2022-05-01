class CreateContests < ActiveRecord::Migration[6.1]
  def change
    create_table :contests do |t|
      t.references :tournament, null: false
      t.integer :round, null: false
      t.integer :sort, null: false
      t.references :upper, foreign_key: { to_table: :competitors }
      t.references :lower, foreign_key: { to_table: :competitors }
      t.references :winner, foreign_key: { to_table: :competitors }

      t.index [:tournament_id, :round, :sort]

      t.timestamps
    end
  end
end
