# frozen_string_literal: true

class RemindersJob < ApplicationJob
  def perform
    User.where(daily_reminder: true).each do |user|
      if user.should_vote?
        ReminderMailer.vote(user: user).deliver_later
      end
    end
  end
end
