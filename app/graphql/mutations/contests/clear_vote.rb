# frozen_string_literal: true

module Mutations
  module Contests
    class ClearVote < Mutations::BaseMutation
      argument :contest_id, ID, required: true, loads: Types::ContestType,
        as: :contest

      field :contest, Types::ContestType, null: false

      def resolve contest:
        if contest.active?
          vote = contest.votes.where(user_id: context[:current_user].id)
          vote.try(:destroy_all)
        end

        { contest: contest }
      end
    end
  end
end
