# frozen_string_literal: true

module Types
  class UserInfoType < Types::BaseObject
    description 'Public information about a user'

    field :username, String, null: true
  end
end
