# frozen_string_literal: true

module Mutations
  module Tournaments
    class RandomTournamentSeeds < Mutations::BaseMutation
      argument :id, ID, required: true, loads: Types::TournamentType,
        as: :tournament

      field :tournament, Types::TournamentType, null: true
      field :errors, [Types::UserError], null: false

      def resolve tournament:
        restrict_tournament_status! tournament

        Competitor.transaction do
          tournament.competitors.shuffle.each_with_index do |competitor, index|
            competitor.update!(seed: index + 1)
          end
        end

        tournament.competitors.reload
        { tournament: tournament, error: [] }
      end
    end
  end
end
