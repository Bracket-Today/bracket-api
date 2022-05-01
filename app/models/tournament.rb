# frozen_string_literal: true

class Tournament < ApplicationRecord
  validates :name, :round_duration, :start_at, presence: true
end
