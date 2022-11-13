# frozen_string_literal: true

module Mutations
  module Tournaments
    class RandomTournamentSeeds < Mutations::BaseMutation
      argument :id, ID, required: true, loads: Types::TournamentType,
        as: :tournament
      argument :strength, String, required: false

      field :tournament, Types::TournamentType, null: true
      field :errors, [Types::UserError], null: false

      def resolve tournament:, strength: 'mild'
        restrict_tournament_status! tournament

        TournamentService::RandomizeSeeds.call(
          tournament: tournament,
          mild: ('mild' == strength)
        )

        tournament.competitors.reload
        { tournament: tournament, error: [] }
      end
    end
  end
end
