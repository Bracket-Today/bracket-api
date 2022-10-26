# frozen_string_literal: true

class Types::DurationUnit < Types::BaseEnum
  value 'SECOND', value: :second
  value 'MINUTE', value: :minute
  value 'HOUR', value: :hour
  value 'DAY', value: :day
end
