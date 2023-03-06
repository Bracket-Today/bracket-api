# frozen_string_literal: true

module Mutations
  module Competitors
    class CreateCompetitor < Mutations::BaseMutation
      argument :tournament_id, ID, required: true, loads: Types::TournamentType
      argument :entity_id, ID, required: false, loads: Types::EntityType
      argument :name, String, required: false
      argument :annotation, String, required: false
      argument :entity_annotation, String, required: false

      field :competitor, Types::CompetitorType, null: true
      field :errors, [Types::UserError], null: false

      def resolve(tournament:, **attributes)
        restrict_tournament_status! tournament

        competitor = CompetitorService::Create.call(
          tournament: tournament, **attributes
        )[:competitor]

        create_resource :competitor, competitor
      end
    end
  end
end
