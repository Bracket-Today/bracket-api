# frozen_string_literal: true

module Types
  class EntityType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :path, String, null: false
    field :annotation, String, null: true
    field :url, String, null: true
  end
end
