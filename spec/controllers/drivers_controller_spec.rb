require 'rails_helper'

RSpec.describe DriversController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:account_admin) }
  let!(:vehicle) { create(:taxi, account_id: user.account_id) }

  before do
    sign_in user
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end

    context 'when there are drivers' do
      let!(:driver) { create(:driver, account_id: user.account_id) }

      it 'returns a success response' do
        get :index
        expect(response).to be_successful
        expect(controller.instance_variable_get('@drivers')).to eq([driver])
      end
    end
  end

  describe 'POST #create' do
    it 'creates a new driver' do
      post :create, params: {
        driver: {
          name: 'Test Driver',
          phone_number: '1234567890',
          birthday: '1990-01-01'
        }
      }

      expect(response).to redirect_to(drivers_path)
      expect(flash[:success]).to eq("Conductor creado exitosamente")
    end

    context 'when user is not authorized' do
      it 'returns a 403 response' do
        user = create(:account_user, vehicle_ids: [vehicle.id])
        sign_in user
        post :create, params: { driver: { name: 'Test Driver', phone_number: '1234567890', birthday: '1990-01-01' } }
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("No tienes permisos para realizar esta acción. Si crees que es un error, por favor contacta al administrador.")
      end
    end
  end
end
