# frozen_string_literal: true

module Mutations
  module Tournaments
    class CloneTournament < Mutations::BaseMutation
      argument :id, ID, required: true, loads: Types::TournamentType,
        as: :tournament

      field :tournament, Types::TournamentType, null: true
      field :errors, [Types::UserError], null: false

      def resolve tournament:
        TournamentService::Clone.call(
          tournament: tournament,
          owner: context[:current_user]
        )
      end
    end
  end
end
