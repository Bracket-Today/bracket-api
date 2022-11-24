# frozen_string_literal: true

class Comment < ApplicationRecord
  scope :ordered, -> { order :id }
  scope :root, -> { where parent_id: nil }

  belongs_to :tournament
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', required: false

  has_many :children, class_name: 'Comment', foreign_key: :parent_id

  validates :body, presence: true
end
