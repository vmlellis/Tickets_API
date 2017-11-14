require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  it do
    is_expected.to have_many(:created_tickets)
      .class_name('Ticket')
      .dependent(:restrict_with_error)
  end

  it do
    is_expected.to have_many(:support_tickets)
      .class_name('Ticket')
      .dependent(:restrict_with_error)
  end

  it do
    is_expected.to have_many(:closed_tickets)
      .class_name('Ticket')
      .dependent(:restrict_with_error)
  end

  it { is_expected.to have_many(:ticket_topics) }

  it { expect(user).to respond_to(:email) }
  it { expect(user).to respond_to(:name) }
  it { expect(user).to respond_to(:password) }
  it { expect(user).to respond_to(:password_confirmation) }
  it { expect(user).to be_valid }

  it { expect(user).to validate_presence_of(:name) }
  it { expect(user).to validate_presence_of(:email) }

  it { expect(user).to validate_presence_of(:password) }
  it { expect(user).to validate_confirmation_of(:password) }

  it { expect(user).to validate_uniqueness_of(:email).case_insensitive }
  it { expect(user).to allow_value('user@user.com').for(:email) }

  context 'when role is admin' do
    let(:role) { 'admin' }
    let(:user) { build(:user, role: role) }

    it { expect(user).to be_admin }
    it { expect(user).to_not be_agent }
    it { expect(user).to_not be_customer }

    describe '#role_name' do
      it 'returns the name of the role' do
        expect(user.role_name).to eq(role)
      end
    end

    describe '#as_json' do
      it 'contains the role' do
        expect(user.as_json[:role]).to eq(role)
      end
    end
  end

  context 'when role is agent' do
    let(:role) { 'agent' }
    let(:user) { build(:user, role: role) }

    it { expect(user).to_not be_admin }
    it { expect(user).to be_agent }
    it { expect(user).to_not be_customer }

    describe '#role_name' do
      it 'returns the name of the role' do
        expect(user.role_name).to eq(role)
      end
    end

    describe '#as_json' do
      it 'contains the role' do
        expect(user.as_json[:role]).to eq(role)
      end
    end
  end

  context 'when role is customer' do
    let(:role) { 'customer' }
    let(:user) { build(:user, role: role) }

    it { expect(user).to_not be_admin }
    it { expect(user).to_not be_agent }
    it { expect(user).to be_customer }

    describe '#role_name' do
      it 'returns the name of the role' do
        expect(user.role_name).to eq(role)
      end
    end

    describe '#as_json' do
      it 'contains the role' do
        expect(user.as_json[:role]).to eq(role)
      end
    end
  end
end
