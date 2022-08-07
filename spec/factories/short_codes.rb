# frozen_string_literal: true

FactoryBot.define do
  factory :short_code do
    sequence(:code) { |n| '%06d' % n }
    association :resource, factory: :tournament
  end
end
