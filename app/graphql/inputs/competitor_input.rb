# frozen_string_literal: true

module Inputs
  class CompetitorInput < Types::BaseInputObject
    argument :name, String, required: true
    argument :seed, Int, required: false
    argument :annotation, String, required: false
    argument :urls, [String], required: false
  end
end
