# frozen_string_literal: true

module Mutations
  module Competitors
    class UpdateCompetitor < Mutations::BaseMutation
      description <<-DESCRIPTION
        Update competitor for a tournament. If entity name changes and an
        existing tournament uses the same entity, a new entity with the new name
        is created.
      DESCRIPTION

      argument :id, ID, required: true, loads: Types::CompetitorType,
        as: :competitor
      argument :name, String, required: true

      field :competitor, Types::CompetitorType, null: true
      field :errors, [Types::UserError], null: false

      def resolve competitor:, name:
        restrict_tournament_status! competitor.tournament, statuses: ['Closed']

        if competitor.shared_entity?
          entity = Entity.new name: name
          entity.set_path
          entity.save!
          competitor.update! entity: entity
        else
          competitor.entity.update! name: name
        end

        { competitor: competitor, errors: [] }
      end
    end
  end
end
