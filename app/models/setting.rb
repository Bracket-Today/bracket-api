# frozen_string_literal: true

class Setting < ApplicationRecord
  def self.active
    Setting.ordered.first_or_initialize
  end
end
