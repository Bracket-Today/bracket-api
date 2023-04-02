# frozen_string_literal: true

FactoryBot.define do
  factory :entity do
    sequence(:name) { |n| "Entity #{n}" }
  end
end
