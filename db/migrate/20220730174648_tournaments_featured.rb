class TournamentsFeatured < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :featured, :boolean, default: false, null: false
  end
end
