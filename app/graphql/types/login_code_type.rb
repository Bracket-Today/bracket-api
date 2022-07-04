# frozen_string_literal: true

module Types
  class LoginCodeType < Types::BaseObject
    description 'UUID of a user based on the login code, including data ' +
      'about logged in user'

    field :uuid, String, 'UUID of user based on login code', null: false
    field :is_current_user, GraphQL::Types::Boolean,

    def is_current_user
      context[:current_user] == object
    end
  end
end
