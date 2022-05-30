# frozen_string_literal: true

class User < ApplicationRecord
  def self.by_uuid uuid
    if uuid.present?
      User.where(uuid: uuid).first_or_create!
    else
      nil
    end
  end
end
