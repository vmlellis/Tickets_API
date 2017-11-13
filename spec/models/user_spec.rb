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

  it { expect(user).to validate_uniqueness_of(:auth_token) }

  describe '#generate_auth_token!' do
    let!(:user) { create(:user) }

    before { allow(Devise).to receive(:friendly_token).and_return('abc123xyz') }

    context 'when current auth_token is null' do
      before { user.auth_token = nil }

      it 'generates a unique auth token' do
        expect(user.generate_auth_token!).to eq('abc123xyz')
      end

      context 'when the current auth token already has been taken' do
        it 'generates another auth token' do
          user_opts = { auth_token: 'abc123xyz', email: Faker::Internet.email }
          existing_user = create(:user, user_opts)

          allow(Devise)
            .to receive(:friendly_token)
            .and_return('abc123xyz', 'abc123xyz', '123XYZtoken')

          expect(user.generate_auth_token!).not_to eq(existing_user.auth_token)
        end
      end
    end

    context 'when current auth_token is empty' do
      before { user.auth_token = '' }

      it 'generates a unique auth token' do
        expect(user.generate_auth_token!).to eq('abc123xyz')
      end
    end

    context 'when current auth_token is present' do
      before { user.auth_token = 'TOKEN@123' }

      it 'returns current token' do
        expect(user.generate_auth_token!).to eq('TOKEN@123')
      end
    end
  end

  context 'when role is admin' do
    let(:role) { 'admin' }
    let(:user) { build(:user, role: role) }

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
