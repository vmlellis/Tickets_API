require 'rails_helper'

RSpec.describe Api::V1::ApplicationController, type: :controller do
  describe 'include the correct concerns' do
    it do
      concern = DeviseTokenAuth::Concerns::SetUserByToken
      expect(controller.class.ancestors).to include(concern)
    end

    it { expect(controller.class.ancestors).to include(Authenticable) }
  end
end
