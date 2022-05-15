# frozen_string_literal: true

module Types
  class ContestType < Types::BaseObject
    field :id, ID, null: false
    field :tournament, Types::TournamentType, null: false
    field :round, Int, null: false
    field :sort, Int, null: false
    field :upper, Types::CompetitorType, null: true
    field :lower, Types::CompetitorType, null: true
    field :winner, Types::CompetitorType, null: true
  end
end
