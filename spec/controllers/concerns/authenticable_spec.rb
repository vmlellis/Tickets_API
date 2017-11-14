require 'rails_helper'

RSpec.describe Authenticable do
  controller(ApplicationController) do
    include Authenticable

    def current_user; end
  end

  let(:app_controller) { subject }

  describe '#authenticate_admin!' do
    controller do
      before_action :authenticate_admin!

      def restricted_action; end
    end

    before do
      allow(app_controller).to receive(:current_user).and_return(user)
      routes.draw do
        get 'restricted_action', to: 'anonymous#restricted_action'
      end
      get :restricted_action
    end

    context 'when user is admin' do
      let(:user) { build(:admin) }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when user is agent' do
      let(:user) { build(:agent) }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns the json data for the error' do
        expect(json_body).to have_key(:error)
      end
    end

    context 'when user is customer' do
      let(:user) { build(:customer) }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns the json data for the error' do
        expect(json_body).to have_key(:error)
      end
    end
  end

  describe '#authenticate_agent!' do
    controller do
      before_action :authenticate_agent!

      def restricted_action; end
    end

    before do
      allow(app_controller).to receive(:current_user).and_return(user)
      routes.draw do
        get 'restricted_action', to: 'anonymous#restricted_action'
      end
      get :restricted_action
    end

    context 'when user is admin' do
      let(:user) { build(:admin) }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when user is agent' do
      let(:user) { build(:agent) }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when user is customer' do
      let(:user) { build(:customer) }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns the json data for the error' do
        expect(json_body).to have_key(:error)
      end
    end
  end

  describe '#authenticate_customer!' do
    controller do
      before_action :authenticate_customer!

      def restricted_action; end
    end

    before do
      allow(app_controller).to receive(:current_user).and_return(user)
      routes.draw do
        get 'restricted_action', to: 'anonymous#restricted_action'
      end
      get :restricted_action
    end

    context 'when user is admin' do
      let(:user) { build(:admin) }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when user is customer' do
      let(:user) { build(:customer) }

      it 'returns status code 204' do
        expect(response).to have_http_status(204)
      end
    end

    context 'when user is agent' do
      let(:user) { build(:agent) }

      it 'returns status code 401' do
        expect(response).to have_http_status(401)
      end

      it 'returns the json data for the error' do
        expect(json_body).to have_key(:error)
      end
    end
  end
end
