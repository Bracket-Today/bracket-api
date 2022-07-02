class UsersLoginCode < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :login_code, :string, limit: 12, unique: true, null: true
  end
end
