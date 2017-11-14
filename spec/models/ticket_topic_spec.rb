require 'rails_helper'

RSpec.describe TicketTopic, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:ticket) }

  it { is_expected.to validate_presence_of(:user_id) }
  it { is_expected.to validate_presence_of(:ticket_id) }
end
