# frozen_string_literal: true

module Mutations
  module Tournaments
    class ScheduleTournament < Mutations::BaseMutation
      argument :id, ID, required: true, loads: Types::TournamentType,
        as: :tournament

      argument :start_at, GraphQL::Types::ISO8601DateTime, required: false
      argument :duration, Int, required: false

      field :tournament, Types::TournamentType, null: true
      field :errors, [Types::UserError], null: false

      def resolve tournament:, start_at: Time.now, duration: 86_400
        restrict_tournament_status! tournament

        attributes = {
          status: 'Pending',
          start_at: start_at,
          duration: duration
        }

        update_resource :tournament, tournament, attributes
      end
    end
  end
end
