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
      3.times { |i| create(:ticket_type, name: "ticket_type_#{i}" ) }
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
    before do
      params = { ticket_type: ticket_type_params }
      post endpoint, params: params.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:ticket_type_params) { attributes_for(:ticket_type) }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves the ticket type in the database' do
        obj = TicketType.find_by(name: ticket_type_params[:name])
        expect(obj).not_to be_nil
      end

      it 'returns json data for the created ticket type' do
        expect(json_body[:name]).to eq(ticket_type_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:ticket_type_params) { attributes_for(:ticket_type, name: '') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not saves the ticket type in the database' do
        obj = TicketType.find_by(name: ticket_type_params[:name])
        expect(obj).to be_nil
      end

      it 'returns the json error for name' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'PUT /ticket_types/:id' do
    let!(:ticket_type) { create(:ticket_type) }

    before do
      params = { ticket_type: ticket_type_params }.to_json
      put "#{endpoint}/#{ticket_type.id}", params: params, headers: headers
    end

    context 'when the request params are valid' do
      let(:ticket_type_params) { { name: 'new_type' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'updates the ticket type in the database' do
        obj = TicketType.find_by(name: ticket_type_params[:name])
        expect(obj).not_to be_nil
      end

      it 'returns json data for the updated ticket type' do
        expect(json_body[:name]).to eq(ticket_type_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:ticket_type_params) { { name: '' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'does not updates the ticket type in the database' do
        obj = TicketType.find_by(name: ticket_type_params[:name])
        expect(obj).to be_nil
      end

      it 'returns the json error for name' do
        expect(json_body[:errors]).to have_key(:name)
      end
    end
  end

  describe 'DELETE /ticket_types/:id' do
    let!(:ticket_type) { create(:ticket_type) }

    before do
      delete "#{endpoint}/#{ticket_type_id}", params: {}, headers: headers
    end

    context 'when the ticket type exists' do
      let(:ticket_type_id) { ticket_type.id }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the ticket type from the database' do
        expect do
          TicketType.find(ticket_type.id)
        end.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the ticket type does not exist' do
      let(:ticket_type_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
