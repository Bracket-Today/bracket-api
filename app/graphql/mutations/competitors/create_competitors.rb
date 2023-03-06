# frozen_string_literal: true

module Mutations
  module Competitors
    class CreateCompetitors < Mutations::BaseMutation
      argument :tournament_id, ID, required: true, loads: Types::TournamentType
      argument :competitors_attributes, [Inputs::CompetitorInput]

      field :tournament, Types::TournamentType, null: false
      field :errors, [Types::UserError], null: false

      def resolve(tournament:, competitors_attributes:)
        restrict_tournament_status! tournament

        competitors_attributes.each do |attributes|
          competitor = CompetitorService::Create.call(
            tournament: tournament,
            **(attributes.to_hash.merge(entity: :match))
          )[:competitor]

          competitor.save!
        end

        { tournament: tournament, errors: [] }
      end
    end
  end
end
