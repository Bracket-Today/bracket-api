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
    field :is_active, GraphQL::Types::Boolean, null: false
    field :current_user_vote, Types::CompetitorType, null: true
    field :upper_prior_score, [Int], null: true
    field :lower_prior_score, [Int], null: true

    def is_active
      object.active?
    end

    def id
      object.id || object.upper.id
    end

    def current_user_vote
      if context[:current_user]
        object.votes.find_by(user_id: context[:current_user].id).
          try(:competitor)
      else
        nil
      end
    end
  end
end
