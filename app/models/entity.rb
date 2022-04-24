# frozen_string_literal: true

class Entity < ApplicationRecord
  scope :ordered, -> { order :name, :id }

  validates :name, :path, presence: true
end
