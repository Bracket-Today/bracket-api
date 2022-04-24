# frozen_string_literal: true

FactoryBot.define do
  factory :entity do
    sequence(:name) { |n| "Entity #{n}" }
    sequence(:path) { |n| "entities/entity-#{'%09d' % n}" }
  end
end
