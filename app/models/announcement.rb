# frozen_string_literal: true

class Announcement < ApplicationRecord
  scope :active, -> {
    where(Announcement[:start_at].lteq(Time.now)).
      where(
        Announcement[:end_at].gteq(Time.now).or(
          Announcement[:end_at].eq(nil)
        )
      )
  }

  scope :always_show, -> { where always_show: true }
  scope :sometimes_show, -> { where always_show: false }

  validates :subject, presence: true

  # Get active announcements marked always show plus one other active
  # announcement (if any available). Used for getting a set of announcments to
  # display on the home page.
  #
  # @return [Array<Announcement>]
  def self.display_subset
    (active.always_show.to_a + [active.sometimes_show.to_a.sample]).compact
  end
end
