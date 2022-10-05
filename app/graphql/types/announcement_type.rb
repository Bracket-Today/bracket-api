# frozen_string_literal: true

module Types
  class AnnouncementType < Types::BaseObject
    field :id, ID, null: false
    field :subject, String, null: false
    field :details, String, null: true
    field :link_text, String, null: true
    field :url, String, null: true
    field :start_at, GraphQL::Types::ISO8601DateTime, null: true
    field :end_at, GraphQL::Types::ISO8601DateTime, null: true
    field :always_show, GraphQL::Types::Boolean, null: false
  end
end
