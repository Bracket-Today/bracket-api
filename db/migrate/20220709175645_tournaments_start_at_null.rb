class TournamentsStartAtNull < ActiveRecord::Migration[6.1]
  def change
    change_column_null :tournaments, :start_at, true
  end
end
