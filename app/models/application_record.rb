# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  include ArelHelpers::ArelTable

  scope :ordered, -> { order :id }
end
