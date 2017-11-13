require 'rails_helper'

RSpec.describe 'Sessions API', type: :request do
  before { host! 'api.domain.dev' }
  let!(:user) { create(:user) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.core.v1',
      'Content-Type' => Mime[:json].to_s
    }
  end

  describe 'POST /sessions' do
    before do
      params = { session: credentials }
      post '/sessions', params: params.to_json, headers: headers
    end

    context 'when the credentials are correct' do
      let(:credentials) { { email: user.email, password: '123456' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json data for the user with auth token' do
        user.reload
        expect(json_body[:auth_token]).to eq(user.auth_token)
      end

      it 'expects auth_token is not empty' do
        expect(json_body[:auth_token]).not_to be_empty
      end
    end

    context 'when the credentials are incorrect' do
      let(:credentials) { { email: user.email, password: 'invalid' } }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns the json data for the error' do
        expect(json_body).to have_key(:error)
      end
    end
  end

  describe 'DELETE /sessions/:id' do
    let!(:user) { create(:user, auth_token: 'abc123xyz') }
    let(:auth_token) { user.auth_token }

    before { delete "/sessions/#{auth_token}", params: {}, headers: headers }

    it 'returns status code 204' do
      expect(response).to have_http_status(204)
    end

    it 'changes the user auth token' do
      expect(User.find_by(auth_token: auth_token)).to be_nil
    end

    it 'removes the user auth token' do
      user.reload
      expect(user.auth_token).to be_nil
    end
  end
end
