# frozen_string_literal: true

module Types
  class TournamentType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :round_duration, Int, null: false
    field :start_at, GraphQL::Types::ISO8601DateTime, null: false
    field :rounds, [Types::RoundType], null: false
  end
end
