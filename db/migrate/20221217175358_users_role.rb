class UsersRole < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :role, :enum, limit: ['Normal', 'Admin'],
      default: 'Normal', null: false
  end
end
