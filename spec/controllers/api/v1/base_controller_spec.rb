require 'rails_helper'

RSpec.describe Api::V1::BaseController, type: :controller do
  describe 'include the correct concerns' do
    it do
      concern = DeviseTokenAuth::Concerns::SetUserByToken
      expect(controller.class.ancestors).to include(concern)
    end
  end
end
