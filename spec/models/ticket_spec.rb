require 'rails_helper'

RSpec.describe Ticket, type: :model do
  let(:ticket) { build(:ticket) }

  it { is_expected.to have_many(:ticket_topics) }

  it { is_expected.to belong_to(:created_by).class_name('User') }
  it { is_expected.to belong_to(:agent).class_name('User') }
  it { is_expected.to belong_to(:closed_by).class_name('User') }
  it { is_expected.to belong_to(:ticket_type) }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:description) }
  it { is_expected.to validate_presence_of(:created_by_id) }
  it { is_expected.to validate_presence_of(:agent_id) }
  it { is_expected.to validate_presence_of(:ticket_type_id) }

  it { is_expected.to respond_to(:title) }
  it { is_expected.to respond_to(:description) }
  it { is_expected.to respond_to(:status) }
  it { is_expected.to respond_to(:status_name) }
  it { is_expected.to respond_to(:created_by_id) }
  it { is_expected.to respond_to(:created_at) }
  it { is_expected.to respond_to(:closed_by_id) }
  it { is_expected.to respond_to(:closed_at) }
  it { is_expected.to respond_to(:agent_id) }
  it { is_expected.to respond_to(:ticket_type_id) }

  describe '#status_name' do
    context 'when ticket is new' do
      it { expect(ticket.status_name).to eq('new') }
    end
  end

  describe '#as_json'
end
