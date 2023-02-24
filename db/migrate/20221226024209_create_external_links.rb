class CreateExternalLinks < ActiveRecord::Migration[6.1]
  def change
    create_table :external_links do |t|
      t.enum :owner_type, limit: ['Competitor', 'Entity', 'Tournament'],
        null: false
      t.bigint :owner_id, null: false
      t.enum :type, limit: ['Other', 'YouTube', 'Amazon', 'Image', 'Video'],
        default: 'Other', null: false
      t.string :short_code
      t.text :url

      t.index [:owner_type, :owner_id]

      t.timestamps
    end
  end
end
