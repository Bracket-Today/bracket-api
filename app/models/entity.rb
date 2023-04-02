# frozen_string_literal: true

class Entity < ApplicationRecord
  include HasShortCode
  include Searchable

  __elasticsearch__.index_name "bracket-#{Rails.env}-entities"
  __elasticsearch__.settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :name, analyzer: 'english'
      indexes :annotation, analyzer: 'english'
      indexes :typename
    end
  end

  scope :ordered, -> { order :name, :id }

  has_many :competitors
  has_many :external_links, as: :owner

  validates :name, presence: true

  def searchable_competitors
    self.competitors.searchable
  end

  def searchable_competitors_count
    self.searchable_competitors.size
  end
end
