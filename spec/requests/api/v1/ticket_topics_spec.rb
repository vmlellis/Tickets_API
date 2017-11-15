require 'rails_helper'

RSpec.describe 'Ticket Topics API', type: :request do
  before { host! 'api.domain.dev' }

  let!(:admin) { create(:admin) }
  let!(:customer) { create(:customer) }
  let!(:agent) { create(:agent) }

  let!(:user) { admin }
  let!(:auth_data) { user.create_new_auth_token }
  let(:headers) do
    {
      'Accept' => 'application/vnd.core.v1',
      'Content-Type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  let!(:ticket) do
    ticket_type = create(:ticket_type)
    opts = { created_by: customer, agent: agent, ticket_type: ticket_type }
    create(:ticket, opts)
  end

  let(:ticket_id) { ticket.id }

  describe 'GET /topics' do
    before do
      create_list(:ticket_topic, 2, ticket: ticket, user: agent)
      create_list(:ticket_topic, 2, ticket: ticket, user: customer)
      get "/tickets/#{ticket_id}/topics", params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns 4 topics' do
      expect(json_body[:records].count).to eq(4)
    end

    context 'when ticket is not in database' do
      let(:ticket_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when is another customer' do
      let(:new_customer) { create(:customer) }
      let(:auth_data) { new_customer.create_new_auth_token }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end

    context 'when is another agent' do
      let(:new_agent) { create(:agent) }
      let(:auth_data) { new_agent.create_new_auth_token }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /topics/:id' do
    let!(:ticket_topic) { create(:ticket_topic, ticket: ticket, user: agent) }
    let(:ticket_topic_id) { ticket_topic.id }

    before do
      endpoint = "/tickets/#{ticket_id}/topics/#{ticket_topic_id}"
      get endpoint, params: {}, headers: headers
    end

    context 'when ticket exists in database' do
      context 'when topic exists in database' do
        it 'returns status code 200' do
          expect(response).to have_http_status(200)
        end

        it 'returns the json for ticket topic' do
          expect(json_body[:description]).to eq(ticket_topic.description)
        end
      end

      context 'when topic not exists in database' do
        let(:ticket_topic_id) { 1000 }

        it 'returns status code 404' do
          expect(response).to have_http_status(404)
        end
      end
    end

    context 'when ticket not exists in database' do
      let(:ticket_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /topics' do
    before do
      params = { ticket_topic: topic_params }.to_json
      post "/tickets/#{ticket_id}/topics", params: params, headers: headers
    end

    context 'when the request params are valid' do
      let(:topic_params) { { description: 'something' } }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'saves in the database' do
        obj = TicketTopic.find_by(description: topic_params[:description])
        expect(obj).not_to be_nil
      end

      it 'returns json data for the created ticket topic' do
        expect(json_body[:description]).to eq(topic_params[:description])
      end

      it 'assigns to the current user' do
        expect(json_body[:user_id]).to eq(user.id)
      end
    end

    context 'when the request params are invalid' do
      let(:topic_params) { { description: '' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'PUT /topics/:id' do
    let!(:ticket_topic) { create(:ticket_topic, ticket: ticket, user: agent) }
    let(:ticket_topic_id) { ticket_topic.id }

    before do
      endpoint = "/tickets/#{ticket_id}/topics/#{ticket_topic_id}"
      params = { ticket_topic: topic_params }.to_json
      put endpoint, params: params, headers: headers
    end

    context 'when the request params are valid' do
      let(:topic_params) { { description: 'new something' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns json data' do
        expect(json_body[:description]).to eq(topic_params[:description])
      end
    end

    context 'when the request params are invalid' do
      let(:topic_params) { { description: '' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end

  describe 'DELETE /topics/:id' do
    pending
  end
end
