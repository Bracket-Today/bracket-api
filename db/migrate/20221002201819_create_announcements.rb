class CreateAnnouncements < ActiveRecord::Migration[6.1]
  def change
    create_table :announcements do |t|
      t.string :subject, null: false
      t.text :details
      t.string :link_text
      t.string :url
      t.datetime :start_at
      t.datetime :end_at
      t.boolean :always_show, null: false, default: false

      t.timestamps

      t.index [:start_at, :end_at]
    end
  end
end
