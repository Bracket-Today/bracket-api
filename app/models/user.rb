# frozen_string_literal: true

class User < ApplicationRecord
  has_many :tournaments, foreign_key: 'owner_id'
  has_many :votes

  def login_code
    super || generate_login_code
  end

  # Generate a unique 6-character code and save as login_code.
  # @return [String]
  def generate_login_code
    code = nil
    while code.nil?
      try_code = SecureRandom.urlsafe_base64[0..5]
      next if try_code =~ /\W/
      next if try_code =~ /_/
      next if User.find_by_login_code(try_code)
      code = try_code
    end

    if self.persisted?
      update_column(:login_code, code)
    else
      self.login_code = code
    end

    code
  end

  def self.by_uuid uuid
    if uuid.present?
      User.where(uuid: uuid).first_or_create!
    else
      nil
    end
  end
end
