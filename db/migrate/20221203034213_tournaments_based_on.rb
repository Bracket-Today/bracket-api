class TournamentsBasedOn < ActiveRecord::Migration[6.1]
  def change
    add_reference :tournaments, :based_on,
      foreign_key: { to_table: :tournaments }
  end
end
