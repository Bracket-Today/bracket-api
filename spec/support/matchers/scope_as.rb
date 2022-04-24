# frozen_string_literal: true

require 'rspec/expectations'

RSpec::Matchers.define :scope_as do |*args|
  collection = args[0]
  indexes = args[1]
  scoped_collection = indexes.map { |index| collection[index] }

  match do |actual|
    actual == scoped_collection
  end

  failure_message do |actual|
    "expected that #{scoped_collection.map(&:id)} would match #{actual.map(&:id)}"
  end
end
