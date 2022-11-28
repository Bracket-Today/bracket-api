class TournamentsCommentStatus < ActiveRecord::Migration[6.1]
  def change
    add_column :tournaments, :comments_status, :enum,
      limit: ['disabled', 'enabled', 'read-only'],
      default: 'enabled', null: false
  end
end
