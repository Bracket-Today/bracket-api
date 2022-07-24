# frozen_string_literal: true

FactoryBot.define do
  factory :contest do
    association :tournament, :active
    round { 1 }
    sequence(:sort) { |n| n }

    trait :with_competitors do
      association :upper, factory: :competitor
      association :lower, factory: :competitor
    end
  end
end
