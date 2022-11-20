class TournamentsNotes < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :notes, :text
  end
end
