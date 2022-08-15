class AddTournamentsVisibility < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :visibility, :enum,
      limit: ['Can Feature', 'Public', 'Private'], default: 'Can Feature',
      null: false
  end
end
