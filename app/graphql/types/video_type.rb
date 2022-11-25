# frozen_string_literal: true

module Types
  class VideoType < Types::BaseObject
    field :id, ID, null: false
    field :subject, String, null: false
    field :youtube_id, String, null: false
    field :start_at, GraphQL::Types::ISO8601DateTime, null: true
    field :end_at, GraphQL::Types::ISO8601DateTime, null: true
    field :always_show, GraphQL::Types::Boolean, null: false
  end
end
