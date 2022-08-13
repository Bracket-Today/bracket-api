# frozen_string_literal: true

class AdminMailer < ApplicationMailer
  def no_featured_tournament
    mail(
      to: 'jared.morgan@preflighttech.com',
      subject: 'No Featured Tournament for Tomorrow'
    )
  end

  def data_check check:, data:
    @check, @data = check, data

    mail(
      to: 'jared.morgan@preflighttech.com',
      subject: "Bracket.Today Data Check Issue: #{@check::DISPLAY_NAME}"
    )
  end
end
