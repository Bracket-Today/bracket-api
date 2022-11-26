class CreateSettings < ActiveRecord::Migration[6.1]
  def change
    create_table :settings do |t|
      t.enum :comments_status, limit: ['disabled', 'enabled', 'read-only'],
        default: 'disabled', null: false

      t.timestamps
    end
  end
end
