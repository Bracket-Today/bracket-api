# frozen_string_literal: true

module Mutations
  module Competitors
    class RemoveCompetitor < Mutations::BaseMutation
      description <<-DESCRIPTION
        Remove competitor from a tournament. If this is the tournament for
        the entity, also delete the entity.
      DESCRIPTION

      argument :id, ID, required: true, loads: Types::CompetitorType,
        as: :competitor

      field :competitor, Types::CompetitorType, null: true
      field :errors, [Types::UserError], null: false

      def resolve competitor:
        entity = competitor.entity
        result = destroy_resource :competitor, competitor

        entity.destroy if entity.competitors.empty?
        competitor.tournament.reseed!

        result
      end
    end
  end
end
