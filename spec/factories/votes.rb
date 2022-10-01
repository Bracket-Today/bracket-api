# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    competitor
    contest { association :contest, upper: competitor, lower: competitor, strategy: :create }
    user
  end
end
