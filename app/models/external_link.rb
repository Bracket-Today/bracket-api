# frozen_string_literal: true

class ExternalLink < ApplicationRecord
  self.inheritance_column = nil

  before_save :update_type

  scope :ordered, -> { order :id }

  belongs_to :owner, polymorphic: true

  validates :type, :url, presence: true

  AMAZON_CODE_MATCH =  /\/(dp|gp)\/(product\/)?(\w+)\//
  YOUTUBE_MATCH = /youtube\.com\/watch\?v=(\w+)/
  YOUTUBE_SHARE_MATCH = /youtu\.be\/(\w+)/
  IMAGE_EXTENSIONS = %w{.png .jpeg .jpg .gif}
  VIDEO_EXTENSIONS = %w{.avi .flv .mkv .mov .mp4}

  def update_type
    return unless 'Other' == self.type

    if url =~ /amazon/ && url =~ AMAZON_CODE_MATCH
      self.type = 'Amazon'
      self.short_code = url.match(AMAZON_CODE_MATCH)[3]
    elsif match = (url.match(YOUTUBE_MATCH) || url.match(YOUTUBE_SHARE_MATCH))
      self.type = 'YouTube'
      self.short_code = match[1]
    elsif IMAGE_EXTENSIONS.include?(File.extname(url).to_s.downcase)
      self.type = 'Image'
    elsif VIDEO_EXTENSIONS.include?(File.extname(url).to_s.downcase)
      self.type = 'Video'
    end
  end
end
