class CreateVideos < ActiveRecord::Migration[6.1]
  def change
    create_table :videos do |t|
      t.string :subject, null: false
      t.string :youtube_id, null: false, limit: 20
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :always_show, null: false, default: false

      t.timestamps

      t.index [:start_at, :end_at]
    end
  end
end
