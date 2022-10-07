# frozen_string_literal: true

module Mutations
  module Users
    class UpdateCurrentUser < Mutations::BaseMutation
      argument :username, String, required: false
      argument :instagram_handle, String, required: false
      argument :twitter_handle, String, required: false

      field :user, Types::UserType, null: false
      field :errors, [Types::UserError], null: false

      def resolve(**attributes)
        update_resource :user, current_user, attributes
      end
    end
  end
end
