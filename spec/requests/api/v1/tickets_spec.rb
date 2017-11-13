require 'rails_helper'

RSpec.describe 'Tickets API', type: :request do
  before { host! 'api.domain.dev' }

  let!(:user) { create(:customer) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.core.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => authorization
    }
  end
  let(:authorization) { user.auth_token }

  describe 'GET /tickets' do
    before do
      create_list(:ticket, 5, user_id: user.id)
    end

    it 'returns status code 200' do
      pending
    end

    it 'returns 5 tickets from database' do
      expect(json_body[:data]).to matcher.to eq(5)
    end
  end
end
