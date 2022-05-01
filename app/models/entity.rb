# frozen_string_literal: true

class Entity < ApplicationRecord
  scope :ordered, -> { order :name, :id }

  has_many :competitors

  validates :name, :path, presence: true
end
