# frozen_string_literal: true

FactoryBot.define do
  factory :comment do
    tournament
    user
    body { 'Hello Everyone' }
  end
end
