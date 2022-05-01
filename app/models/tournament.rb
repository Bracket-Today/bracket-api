# frozen_string_literal: true

class Tournament < ApplicationRecord
  has_many :competitors
  has_many :contests

  validates :name, :round_duration, :start_at, presence: true
end
