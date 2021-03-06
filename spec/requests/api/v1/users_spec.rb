require 'rails_helper'

RSpec.describe 'Users API', type: :request do
  before { host! 'api.domain.dev' }
  let!(:endpoint) { '/users' }

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

  let(:user_id) { user.id }

  describe 'GET /users' do
    context 'when no filter is sent' do
      before do
        create_list(:user, 5)
        get endpoint, params: {}, headers: headers
      end

      it 'returns status code 200' do
        expect(response).to have_http_status(200)
      end

      it 'returns 6 users from database' do
        expect(json_body[:records].count).to eq(6)
      end

      it 'returns total of records equal to 6' do
        expect(json_body[:total]).to eq(6)
      end

      context 'when current user is customer' do
        let(:customer) { create(:customer) }
        let(:auth_data) { customer.create_new_auth_token }

        it 'returns status code 401' do
          expect(response).to have_http_status(401)
        end
      end
    end

    context 'when filter and sorting params are sent' do
      let!(:user1) { create(:user, name: 'John Wick') }
      let!(:user2) { create(:user, name: 'Matthew Wick') }
      let!(:user3) { create(:user, name: 'Doug Thomas') }

      before do
        get "#{endpoint}?#{get_params}", params: {}, headers: headers
      end

      let(:get_params) { 'q[name_cont]=wick&q[s]=name+DESC' }

      it 'returns only the users matching' do
        returned_user_names = json_body[:records].map { |t| t[:name] }
        expect(returned_user_names).to eq([user2.name, user1.name])
      end

      context 'when per_page is 1' do
        let(:get_params) { 'q[name_cont]=wick&q[s]=name+DESC&per_page=1' }

        it 'expect only 1 user' do
          returned_user_names = json_body[:records].map { |t| t[:name] }
          expect(returned_user_names).to eq([user2.name])
        end
      end
    end
  end

  describe 'GET /users/:id' do
    before { get "#{endpoint}/#{user_id}", params: {}, headers: headers }

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
      post endpoint, params: { user: user_params }.to_json, headers: headers
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
      put "#{endpoint}/#{user_id}", params: params.to_json, headers: headers
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
    before { delete "#{endpoint}/#{user_id}", params: {}, headers: headers }

    context 'when the user is current user' do
      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end
    end

    context 'when the user exists' do
      let!(:other_user) { create(:admin, email: 'other@email.com') }
      let(:user_id) { other_user.id }
      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end

      it 'removes the user from the database' do
        expect(User.find_by(id: other_user.id)).to be_nil
      end
    end

    context 'when the user does not exist' do
      let(:user_id) { 1000 }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end
