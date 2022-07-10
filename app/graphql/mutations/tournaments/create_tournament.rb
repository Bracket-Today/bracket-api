# frozen_string_literal: true

module Mutations
  module Tournaments
    class CreateTournament < Mutations::BaseMutation
      argument :name, String, required: true
      argument :round_duration, GraphQL::Types::ID, required: false
      argument :start_at, GraphQL::Types::ISO8601DateTime, required: false

      field :tournament, Types::TournamentType, null: true
      field :errors, [Types::UserError], null: false

      def resolve(**attributes)
        attributes = attributes.merge(owner: context[:current_user])
        create_resource :tournament, Tournament.new(attributes)
      end
    end
  end
end
