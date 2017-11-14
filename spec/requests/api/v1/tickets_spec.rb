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

  describe 'POST /tickets' do
    context 'when the request params are valid' do
      it 'returns status code 201'
      it 'saves the ticket type in the database'
      it 'returns json data for the created ticket type'
      it 'assigns the created ticket to the current user'
      it 'assigns the created ticket to an agent'

      context 'when current user is agent' do
        it 'returns status code 401'
      end
    end
  end
end
