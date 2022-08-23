# frozen_string_literal: true

class DevelopmentMailInterceptor
  def self.delivering_email(message)
    if @development_mail_interceptor.nil?
      @development_mail_interceptor =
        (Rails.env.development? || Rails.env.staging? || Rails.env.uat?)
    end

    if @development_mail_interceptor
      return true if message.subject.to_s.strip =~ /\AUnhandled/

      message.subject = "[#{message.to}#{message.cc}] #{message.subject}"

      message.to = Preflight::DEVELOPER_EMAILS
      message.cc = nil
      message.bcc = nil
    end
  end
end
