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

  describe 'POST /auth' do
    before { post endpoint, params: user_params.to_json, headers: headers }

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user, name: 'a name') }

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

  describe 'POST /auth/sign_in' do
    let(:headers) do
      {
        'Accept' => 'application/vnd.core.v1',
        'Content-Type' => Mime[:json].to_s
      }
    end

    before do
      post "#{endpoint}/sign_in", params: credentials.to_json, headers: headers
    end

    context 'when the credentials are correct' do
      let(:credentials) { { email: user.email, password: '123456' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the authentication data in headers' do
        expect(response.headers).to have_key('access-token')
        expect(response.headers).to have_key('uid')
        expect(response.headers).to have_key('client')
      end
    end

    context 'when the credentials are incorrect' do
      let(:credentials) { { email: user.email, password: 'invalid' } }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end

  describe 'DELETE /auth/sign_out' do
    let!(:user) { create(:user) }

    before { delete "#{endpoint}/sign_out", params: {}, headers: headers }

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'changes the user access-token' do
      user.reload
      expect(user).not_to be_valid_token(
        auth_data['access-token'], auth_data['client']
      )
    end
  end
end
