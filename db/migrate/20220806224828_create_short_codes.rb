class CreateShortCodes < ActiveRecord::Migration[6.1]
  def change
    create_table :short_codes do |t|
      t.string :code, limit: 6, unique: true, null: false
      t.enum :resource_type,
        limit: ['Tournament', 'Entity', 'User', 'Competitor'],
        null: false
      t.bigint :resource_id, null: false

      t.timestamps

      t.index [:resource_type, :resource_id]
    end
  end
end
