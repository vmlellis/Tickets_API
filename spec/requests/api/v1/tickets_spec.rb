require 'rails_helper'

RSpec.describe 'Tickets API', type: :request do
  before { host! 'api.domain.dev' }
  let!(:endpoint) { '/tickets' }

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
      get endpoint, params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 5 tickets from database' do
      expect(json_body[:records].count).to eq(5)
    end
  end

  describe 'GET /tickets/:id' do
    let(:ticket) { create(:ticket, created_by: customer, agent: agent) }

    before { get "#{endpoint}/#{ticket.id}", params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the json for ticket' do
      expect(json_body[:title]).to eq(ticket.title)
    end
  end
end
