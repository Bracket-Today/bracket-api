# frozen_string_literal: true

module Types
  class EntityType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :full_path, String, null: false
    field :annotation, String, null: true
    field :external_links, [Types::ExternalLinkType], null: false
    field :searchable_competitors, [Types::CompetitorType], null: false
    field :searchable_competitors_count, Int, null: false
  end
end
