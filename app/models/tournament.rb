# frozen_string_literal: true

class Tournament < ApplicationRecord
  has_many :competitors

  validates :name, :round_duration, :start_at, presence: true
end
