require 'rails_helper'

RSpec.describe 'Ticket Types API', type: :request do
  before { host! 'api.domain.dev' }
  let!(:endpoint) { '/ticket_types' }

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
      get endpoint, params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 3 ticket types from database' do
      expect(json_body[:records].count).to eq(3)
    end

    context 'when user is agent' do
      let(:agent) { create(:agent) }
      let(:authorization) { agent.auth_token }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when user is customer' do
      let(:customer) { create(:customer) }
      let(:authorization) { customer.auth_token }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /ticket_types/:id' do
    let(:ticket_type) { create(:ticket_type) }

    before do
      get "#{endpoint}/#{ticket_type.id}", params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for ticket type' do
      expect(json_body[:name]).to eq(ticket_type.name)
    end
  end

  describe 'POST /ticket_types' do
  end

  describe 'PUT /ticket_types/:id' do
  end

  describe 'DELETE /ticket_types/:id' do
  end
end
