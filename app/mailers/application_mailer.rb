# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'Bracket.Today <info@bracket.today>'
  layout 'mailer'
end
