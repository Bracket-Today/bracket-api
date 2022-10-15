class AnnotationFields < ActiveRecord::Migration[6.1]
  def change
    add_column :competitors, :annotation, :string, limit: 50
    add_column :entities, :annotation, :string, limit: 50
  end
end
