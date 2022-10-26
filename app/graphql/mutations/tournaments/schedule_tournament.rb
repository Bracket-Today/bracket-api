# frozen_string_literal: true

module Mutations
  module Tournaments
    class ScheduleTournament < Mutations::BaseMutation
      argument :id, ID, required: true, loads: Types::TournamentType,
        as: :tournament

      argument :start_at, GraphQL::Types::ISO8601DateTime, required: false
      argument :round_duration_quantity, Int, required: false
      argument :round_duration_unit, Types::DurationUnit, required: false
      argument :visibility, String, required: false

      field :tournament, Types::TournamentType, null: true
      field :errors, [Types::UserError], null: false

      def resolve tournament:, start_at: Time.now, round_duration_quantity: nil,
        round_duration_unit: :second, visibility: nil

        restrict_tournament_status! tournament

        attributes = { status: 'Pending', start_at: start_at }

        if visibility
          attributes[:visibility] = visibility
        end

        if round_duration_quantity
          attributes[:round_duration] = Tournament.duration_in_seconds(
            round_duration_quantity,
            round_duration_unit
          )
        end

        update_resource :tournament, tournament, attributes
      end
    end
  end
end
