require 'rails_helper'

RSpec.describe 'Ticket Types API', type: :request do
  before { host! 'api.domain.dev' }

  let!(:user) { create(:admin) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.core.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => authorization
    }
  end
  let(:authorization) { user.auth_token }

  describe 'GET /ticket_types' do
    before do
      create_list(:ticket_type, 3)
      get '/ticket_types', params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 3 ticket types from database' do
      expect(json_body[:data].count).to eq(3)
    end
  end
end
