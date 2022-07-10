class TournamentsOwner < ActiveRecord::Migration[6.1]
  def change
    add_reference :tournaments, :owner, foreign_key: { to_table: 'users' },
      null: true
  end
end
