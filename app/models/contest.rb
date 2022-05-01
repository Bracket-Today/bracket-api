# frozen_string_literal: true

class Contest < ApplicationRecord
  scope :ordered, -> { order :round, :sort }

  belongs_to :tournament
  belongs_to :upper, class_name: 'Competitor', required: false
  belongs_to :lower, class_name: 'Competitor', required: false
  belongs_to :winner, class_name: 'Competitor', required: false

  validates :round, :sort, presence: true
end
