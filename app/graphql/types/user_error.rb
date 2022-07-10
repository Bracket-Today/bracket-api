# frozen_string_literal: true

class Types::UserError < Types::BaseObject
  description 'A user-readable error'

  field :message, String, null: false,
    description: 'A description of the error'
  field :path, [String], null: true,
    description: 'From which input value this error came'
end
