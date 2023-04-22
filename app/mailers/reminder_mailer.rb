# frozen_string_literal: true

class ReminderMailer < ApplicationMailer
  def vote user:
    mail(
      to: user.email,
      subject: 'Time to vote on bracket.today',
      asm: { group_id: 26087 }
    )
  end
end
