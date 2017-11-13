require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

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


  context 'when role is admin' do
    let(:user) { build(:user, role: 'admin') }

    describe '#role_name' do
      it 'returns the name of the role' do
        expect(user.role_name).to eq('admin')
      end
    end
  end

  context 'when role is agent' do
    let(:user) { build(:user, role: 'agent') }

    describe '#role_name' do
      it 'returns the name of the role' do
        expect(user.role_name).to eq('agent')
      end
    end
  end

  context 'when role is customer' do
    let(:user) { build(:user, role: 'customer') }

    describe '#role_name' do
      it 'returns the name of the role' do
        expect(user.role_name).to eq('customer')
      end
    end
  end
end
