# frozen_string_literal: true

module DataCheckService
  class TournamentSeeds
    include Service

    DISPLAY_NAME = 'Tournament Seeds - Competitor Seeds Missing'

    DESCRIPTION = <<-EODESCRIPTION
      One or more competitors are missing seeds. To fix, run:
      Tournament.find(ID).reseed!
    EODESCRIPTION

    def call
      tournaments = Tournament.seeds_required.
        joins(:competitors).where(competitors: { seed: nil }).distinct

      if tournaments.any?
        AdminMailer.data_check(check: self.class, data: tournaments).deliver_now
      end
    end
  end
end
