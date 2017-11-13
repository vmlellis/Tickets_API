require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user) }

  it { expect(user).to respond_to(:email) }
  it { expect(user).to respond_to(:name) }
  it { expect(user).to respond_to(:password) }
  it { expect(user).to respond_to(:password_confirmation) }
  it { expect(user).to be_valid }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }

  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to validate_confirmation_of(:password) }

  it { expect(user).to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to allow_value('user@user.com').for(:email) }

  context 'when role is admin' do
    pending
  end

  context 'when role is agent' do
    pending
  end

  context 'when role is consumer' do
    pending
  end
end
