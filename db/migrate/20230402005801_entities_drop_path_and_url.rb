class EntitiesDropPathAndUrl < ActiveRecord::Migration[6.1]
  def change
    remove_column :entities, :path
    remove_column :entities, :url
  end
end
