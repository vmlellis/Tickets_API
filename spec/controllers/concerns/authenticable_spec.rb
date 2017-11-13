require 'rails_helper'

RSpec.describe Authenticable do
  controller(ApplicationController) do
    include Authenticable
  end

  let(:app_controller) { subject }

  describe '#current_user' do
    let!(:user) { create(:user, auth_token: Devise.friendly_token) }

    before do
      req = double(headers: { 'Authorization' => user.auth_token })
      allow(app_controller).to receive(:request).and_return(req)
    end

    it 'returns the user from the authorization header' do
      expect(app_controller.current_user).to eq(user)
    end
  end

  describe '#authenticate_with_token' do
    controller do
      before_action :authenticate_with_token!

      def restricted_action; end
    end

    context 'when there is no user logged in' do
      before do
        allow(app_controller).to receive(:current_user).and_return(nil)
        routes.draw do
          get 'restricted_action', to: 'anonymous#restricted_action'
        end
        get :restricted_action
      end

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns the json data for the error' do
        expect(json_body).to have_key(:error)
      end
    end
  end
end
