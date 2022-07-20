# frozen_string_literal: true

class Entity < ApplicationRecord
  scope :ordered, -> { order :name, :id }

  has_many :competitors

  validates :name, :path, presence: true

  def set_path prefix: '/misc'
    slug = self.name.downcase.gsub(/[^\w\s]/, '').gsub(/\s+/, '-')
    self.path = "#{prefix}/#{slug}"
  end
end
