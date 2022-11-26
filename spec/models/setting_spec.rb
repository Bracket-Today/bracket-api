# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Setting, type: :model do
  subject { FactoryBot.build(:setting) }

  it { is_expected.to be_valid }
end
