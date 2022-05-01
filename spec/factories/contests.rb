# frozen_string_literal: true

FactoryBot.define do
  factory :contest do
    tournament
    round { 1 }
    sequence(:sort) { |n| n }
  end
end
