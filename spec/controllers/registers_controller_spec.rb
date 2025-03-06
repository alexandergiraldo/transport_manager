require 'rails_helper'

RSpec.describe RegistersController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:account_admin) }
  let!(:vehicle) { create(:taxi, account_id: user.account_id) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end

    context "when there are registers" do
      let!(:register) { create(:register, vehicle_id: vehicle.id, user_id: user.id) }

      it "returns a success response" do
        get :index
        expect(response).to be_successful
        expect(controller.instance_variable_get('@registers')).to eq([register])
      end
    end
  end
end
