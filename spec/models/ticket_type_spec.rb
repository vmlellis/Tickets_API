require 'rails_helper'

RSpec.describe TicketType, type: :model do
  it { is_expected.to have_many(:tickets) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
  it { is_expected.to respond_to(:name) }
end
