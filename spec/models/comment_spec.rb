# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject(:comment) { FactoryBot.build(:comment) }

  it { is_expected.to be_valid }

  describe 'scopes' do
    let!(:comments) do
      retval = FactoryBot.create_list(:comment, 2)
      retval << FactoryBot.create(:comment, parent: retval[1])
      retval
    end

    describe '.ordered' do
      subject { Comment.ordered }
      it { is_expected.to scope_as(comments, [0,1,2]) }
    end

    describe '.root' do
      subject { Comment.root.ordered }
      it { is_expected.to scope_as(comments, [0,1]) }
    end
  end

  it { is_expected.to belong_to(:tournament) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:parent).optional.class_name('Comment') }

  it { is_expected.to have_many(:children).class_name('Comment') }

  it { is_expected.to validate_presence_of(:body) }
end
