require 'rails_helper'

RSpec.describe 'Auth API', type: :request do
  before { host! 'api.domain.dev' }
  let!(:endpoint) { '/auth' }

  let!(:user) { create(:admin) }
  let!(:auth_data) { user.create_new_auth_token }
  let!(:headers) do
    {
      'Accept' => 'application/vnd.core.v1',
      'Content-Type' => Mime[:json].to_s,
      'access-token' => auth_data['access-token'],
      'uid' => auth_data['uid'],
      'client' => auth_data['client']
    }
  end

  describe 'GET /auth/validate_token' do
    context 'when the request headers are valid' do
      before { get "#{endpoint}/validate_token", params: {}, headers: headers }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the user' do
        expect(json_body[:data][:id]).to eq(user.id)
      end
    end

    context 'when the request headers are invalid' do
      before do
        headers['access-token'] = 'invalid_token'
        get "#{endpoint}/validate_token", params: {}, headers: headers
      end

      let(:user_id) { 1000 }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  # Registration
  describe 'POST /auth' do
    before { post endpoint, params: user_params.to_json, headers: headers }

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user) }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns json data for the created user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { attributes_for(:user, email: 'invalid_email@') }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  # Update
  describe 'PUT /auth' do
    before { put endpoint, params: user_params.to_json, headers: headers }

    context 'when the request params are valid' do
      let(:user_params) { { email: 'new_email@tickets.com' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json data for the updated user' do
        expect(json_body[:data][:email]).to eq(user_params[:email])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { { email: 'invalid_email@' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /auth' do
    before { delete endpoint, params: {}, headers: headers }

    context 'when the user exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'removes the user from the database' do
        expect(User.find_by(id: user.id)).to be_nil
      end
    end
  end
end