# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def no_featured_tournament
    mail(
      to: 'jared.morgan@preflighttech.com',
      subject: 'No Featured Tournament for Tomorrow'
    )
  end
end
