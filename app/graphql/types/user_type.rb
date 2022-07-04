# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    field :id, ID, null: false
    field :login_code, String, null: false
    field :votes_count, Int, null: false

    def votes_count
      object.votes.count
    end
  end
end
