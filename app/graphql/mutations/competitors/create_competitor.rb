# frozen_string_literal: true

module Mutations
  module Competitors
    class CreateCompetitor < Mutations::BaseMutation
      argument :tournament_id, ID, required: true, loads: Types::TournamentType
      argument :entity_id, ID, required: false, loads: Types::EntityType
      argument :name, String, required: false

      field :competitor, Types::CompetitorType, null: true
      field :errors, [Types::UserError], null: false

      def resolve tournament:, entity: nil, name: nil
        restrict_tournament_status! tournament

        if entity.nil?
          entity = Entity.new(name: name)
          entity.set_path
          entity.save!
        end

        competitor = tournament.competitors.new(entity: entity)
        competitor.seed = tournament.competitors.count + 1

        create_resource :competitor, competitor
      end
    end
  end
end
