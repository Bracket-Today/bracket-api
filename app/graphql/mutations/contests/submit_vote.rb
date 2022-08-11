# frozen_string_literal: true

module Mutations
  module Contests
    class SubmitVote < Mutations::BaseMutation
      argument :contest_id, ID, required: true, loads: Types::ContestType,
        as: :contest
      argument :competitor_id, ID, required: true, loads: Types::CompetitorType,
        as: :competitor

      field :contest, Types::ContestType, null: false

      def resolve contest:, competitor:
        vote = contest.votes.where(user_id: context[:current_user].id).
          first_or_initialize
        vote.competitor = competitor
        vote.save # This could fail due to rapid double-click and can be ignored

        { contest: contest }
      end
    end
  end
end
