require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  before { host! 'api.domain.dev' }

  let!(:user) { create(:admin) }
  let(:headers) do
    {
      'Accept' => 'application/vnd.core.v1',
      'Content-Type' => Mime[:json].to_s,
      'Authorization' => authorization
    }
  end
  let(:authorization) { user.auth_token }

  let(:user_id) { user.id }

  describe 'GET /users' do
    before do
      get '/users', params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns a list of users'

    it 'returns total of records'

    context 'when current user is customer' do
      let(:customer) { create(:customer) }
      let(:authorization) { customer.auth_token }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end
  end

  describe 'GET /users/:id' do
    before do
      get "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when the user exists' do
      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the user' do
        expect(json_body[:id]).to eq(user.id)
      end
    end

    context 'when the user does not exist' do
      let(:user_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'POST /users' do
    before do
      post '/users', params: { user: user_params }.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { attributes_for(:user, email: Faker::Internet.email) }

      it 'returns status code 201' do
        expect(response).to have_http_status(201)
      end

      it 'returns json data for the created user' do
        expect(json_body[:email]).to eq(user_params[:email])
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

  describe 'PUT /users/:id' do
    before do
      params = { user: user_params }
      put "/users/#{user_id}", params: params.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { { email: 'new_email@tickets.com' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json data for the updated user' do
        expect(json_body[:email]).to eq(user_params[:email])
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

  describe 'DELETE /users/:id' do
    before do
      delete "/users/#{user_id}", params: {}, headers: headers
    end

    context 'when the user exists' do
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the user from the database' do
        expect(User.find_by(id: user.id)).to be_nil
      end
    end

    context 'when the user does not exist' do
      let(:user_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'GET /users/current' do
    let!(:current_user) { create(:customer) }
    let(:authorization) { current_user.auth_token }

    before do
      get '/users/current', params: {}, headers: headers
    end

    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns the current user' do
      expect(json_body[:id]).to eq(current_user.id)
    end
  end

  describe 'PUT /users/current' do
    let!(:current_user) { create(:customer) }
    let(:authorization) { current_user.auth_token }

    before do
      params = { user: user_params }
      put '/users/current', params: params.to_json, headers: headers
    end

    context 'when the request params are valid' do
      let(:user_params) { { name: 'NEW NAME' } }

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns the json data for the updated user' do
        expect(json_body[:name]).to eq(user_params[:name])
      end
    end

    context 'when the request params are invalid' do
      let(:user_params) { { name: '' } }

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end

      it 'returns the json data for the errors' do
        expect(json_body).to have_key(:errors)
      end
    end
  end
end
