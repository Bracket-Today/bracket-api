# frozen_string_literal: true

module DataCheckService
  class UnconfirmedUsers
    include Service

    DISPLAY_NAME = 'Unconfirmed Users'

    DESCRIPTION = <<-EODESCRIPTION
      One or more users have registered emails but not confirmed. This may not
      be a problem. See BKT1818.
    EODESCRIPTION

    def call
      users = User.where.not(email: nil).where(confirmed_at: nil)

      if users.any?
        AdminMailer.data_check(check: self.class, data: users).deliver_now
      end
    end
  end
end
