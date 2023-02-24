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
      argument :annotation, String, required: false
      argument :entity_annotation, String, required: false
      argument :url, String, required: false

      field :competitor, Types::CompetitorType, null: true
      field :errors, [Types::UserError], null: false

      def resolve competitor:, name:, annotation: nil, entity_annotation: nil,
        url: nil

        restrict_tournament_status! competitor.tournament, statuses: ['Closed']
        annotation = nil if annotation.blank?

        if competitor.shared_entity?
          entity = Entity.new name: name, annotation: entity_annotation
          entity.set_path
          entity.save!
        else
          if entity_annotation.present?
            competitor.entity.annotation = entity_annotation
          end

          competitor.entity.update! name: name
        end

        competitor.update! annotation: annotation

        if url.present?
          competitor.entity.external_links.create! url: url
        end

        { competitor: competitor, errors: [] }
      end
    end
  end
end
