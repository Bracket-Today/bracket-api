# frozen_string_literal: true

module Types
  class TournamentType < Types::BaseObject
    field :id, ID, null: false
    field :name, String, null: false
    field :status, String, null: false
    field :round_duration, Int, null: false
    field :start_at, GraphQL::Types::ISO8601DateTime, null: true
    field :competitors, [Types::CompetitorType], null: false
    field :rounds, [Types::RoundType], null: false
    field :round, Types::RoundType, null: false do
      argument :number, Int, required: false
    end
    field :winner, Types::CompetitorType, null: true
    field :voters_count, Int, null: false
    field :votes_count, Int, null: false
    field :contests_count, Int, null: false
    field :current_user_voted_winner_count, Int, null: false

    def current_user_voted_winner_count
      object.votes.where(user_id: context[:current_user].try(:id)).
        select { |vote| vote.contest.winner_id == vote.competitor_id }.
        length
    end
  end
end
