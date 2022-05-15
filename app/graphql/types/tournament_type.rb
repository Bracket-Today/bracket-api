# frozen_string_literal: true

module Types
  class TournamentType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :round_duration, Int, null: false
    field :start_at, GraphQL::Types::ISO8601DateTime, null: false
    field :contests, [Types::ContestType], null: false
  end
end
