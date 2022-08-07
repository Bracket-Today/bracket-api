# frozen_string_literal: true

module HasShortCode
  extend ActiveSupport::Concern

  included do
    has_many :short_codes, as: :resource
  end

  # @return [String] Short code used as identifier in urls.
  def short_code
    return nil unless self.persisted?

    code = short_codes.first.try(:code)
    return code if code

    code = ShortCodeService::Suggest.call
    short_codes.create!(resource: self, code: code)
    code
  end

  # @return [String] Minimal path to get resource.
  def short_path
    "/~/#{short_code}"
  end

  # @return [String] Full path, useful for SEO.
  def full_path
    "/#{self.class.table_name.dasherize}/#{short_code}/#{slug}"
  end

  # @return [String] Slug from name, or id.
  def slug
    if self[:name]
      self.name.downcase.gsub(/[^\w\s]/, '').gsub(/\s+/, '-')
    else
      self.id
    end
  end
end
