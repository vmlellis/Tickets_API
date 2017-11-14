require 'rails_helper'

RSpec.describe 'Tickets API', type: :request do
  before { host! 'api.domain.dev' }

  let!(:customer) { create(:customer) }
  let!(:agent) { create(:agent) }
  let!(:user) { create(:admin)  }
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
      create_list(:ticket, 5, created_by: customer, agent: agent)
      get '/tickets', params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 5 tickets from database' do
      expect(json_body[:records].count).to eq(5)
    end
  end
end
