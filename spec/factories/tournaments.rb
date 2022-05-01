# frozen_string_literal: true

FactoryBot.define do
  factory :tournament do
    sequence(:name) { |n| "Entity #{n}" }
    start_at { Time.now.utc.beginning_of_day }
  end
end
