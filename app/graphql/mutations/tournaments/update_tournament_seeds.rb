# frozen_string_literal: true

module Mutations
  module Tournaments
    class UpdateTournamentSeeds < Mutations::BaseMutation
      argument :id, ID, required: true, loads: Types::TournamentType,
        as: :tournament
      argument :competitor_ids, [ID], required: true

      field :tournament, Types::TournamentType, null: true
      field :errors, [Types::UserError], null: false

      def resolve tournament:, competitor_ids:
        if ['Active', 'Closed'].include?(tournament.status)
          return {
            tournament: tournament,
            errors: [
              { message: "Tournament is #{tournament.status}" }
            ]
          }
        end

        Competitor.transaction do
          competitor_ids.each_with_index do |competitor_id, index|
            tournament.competitors.find(competitor_id).update!(seed: index + 1)
          end
        end

        tournament.competitors.reload
        { tournament: tournament, error: [] }
      end
    end
  end
end
