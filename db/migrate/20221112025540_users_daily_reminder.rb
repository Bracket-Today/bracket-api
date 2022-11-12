class UsersDailyReminder < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :daily_reminder, :boolean, default: false, null: false
  end
end
