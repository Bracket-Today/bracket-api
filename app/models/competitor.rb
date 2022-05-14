# frozen_string_literal: true

class Competitor < ApplicationRecord
  scope :ordered, -> { order :seed, :id }

  belongs_to :entity
  belongs_to :tournament

  delegate :name, to: :entity
end
