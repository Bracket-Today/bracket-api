class CreateTournaments < ActiveRecord::Migration[6.1]
  def change
    create_table :tournaments do |t|
      t.string :name, index: { length: 20 }, null: false
      t.integer :round_duration, null: false, default: 1.day
      t.datetime :start_at, null: false

      t.timestamps
    end
  end
end
