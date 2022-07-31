# frozen_string_literal: true

class CheckFeaturedScheduleJob < ApplicationJob
  def perform
    tomorrow_featured = Tournament.featured.where(
      start_at: (Date.tomorrow.beginning_of_day..Date.tomorrow.end_of_day)
    )

    if tomorrow_featured.empty?
      AdminMailer.no_featured_tournament.deliver_now
    end
  end
end
