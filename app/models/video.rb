# frozen_string_literal: true

class Video < ApplicationRecord
  scope :active, -> {
    where(Video[:start_at].lteq(Time.now)).
      where(
        Video[:end_at].gteq(Time.now).or(
          Video[:end_at].eq(nil)
        )
      )
  }

  scope :always_show, -> { where always_show: true }
  scope :sometimes_show, -> { where always_show: false }

  validates :subject, :youtube_id, presence: true

  # Get active videos marked always show plus one other active
  # video (if any available). Used for getting a set of videos to
  # display on the home page.
  #
  # @return [Array<Video>]
  def self.display_subset
    (active.always_show.to_a + [active.sometimes_show.to_a.sample]).compact
  end
end
