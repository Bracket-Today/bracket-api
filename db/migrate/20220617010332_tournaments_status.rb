class TournamentsStatus < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :status, :enum, limit: [
      'Building', 'Seeding', 'Pending', 'Active', 'Closed'
    ], default: 'Building', null: false
  end
end
