# frozen_string_literal: true

class ShortCode < ApplicationRecord
  belongs_to :resource, polymorphic: true

  validates :code, presence: true

  # Get resource based on code, optionally limited by type
  #
  # @param code [String] Short code
  # @param type [String] Resource type
  # @return [ActiveRecord::Base]
  def self.resource code, type: nil
    if type
      find_by(code: code, resource_type: type).try(:resource)
    else
      find_by(code: code).try(:resource)
    end
  end
end
