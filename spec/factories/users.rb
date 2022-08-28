# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:uid) { |n| n.to_s }
  end
end
