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
      ticket_type = create(:ticket_type)
      opts = { created_by: customer, agent: agent, ticket_type: ticket_type }
      create_list(:ticket, 5, opts)
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
    before do
      params = { ticket: ticket_params }
      post endpoint, params: params.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let!(:customer) { create(:customer) }

      let(:ticket_params) do
        ticket_type = create(:ticket_type)
        attributes_for(:ticket).merge(ticket_type_id: ticket_type.id)
      end

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves the ticket in the database' do
        obj = Ticket.find_by(title: ticket_params[:title])
        expect(obj).not_to be_nil
      end

      it 'returns json data for the created ticket type' do
        expect(json_body[:description]).to eq(ticket_params[:description])
      end

      it 'assigns the created ticket to the current user' do
        expect(json_body[:created_by_id]).to eq(user.id)
      end

      it 'assigns the created ticket to an agent' do
        allow(User).to receive(:random_agent).and_return(agent)
        expect(json_body[:agent_id]).to eq(agent.id)
      end

      context 'when current user is agent' do
        let(:authorization) { agent.auth_token }

        it 'returns status code 401' do
          expect(response).to have_http_status(401)
        end
      end
    end
  end

  describe 'PUT /tickets/:id'

  describe 'DELETE /tickets/:id'
end
