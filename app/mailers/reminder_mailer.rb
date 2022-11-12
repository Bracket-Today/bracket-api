# frozen_string_literal: true

class ReminderMailer < ApplicationMailer
  def vote user:
    mail(
      to: user.email,
      subject: 'Time to vote on bracket.today'
    )
  end
end
