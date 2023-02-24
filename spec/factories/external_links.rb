# frozen_string_literal: true

FactoryBot.define do
  factory :external_link do
    association :owner, factory: :entity
    url { 'http://example.com' }
  end
end
