require 'rails_helper'

RSpec.describe VehiclesController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:user) { create(:account_admin) }
  let(:vehicle) { create(:taxi, account_id: user.account_id) }

  before do
    sign_in user
  end

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to be_successful
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: vehicle.id }
      expect(response).to be_successful
    end
  end

  describe "GET #new" do
    it "returns a success response" do
      get :new
      expect(response).to be_successful
    end
  end

  describe "POST #create" do
    it "returns a success response" do
      post :create, params: {
        vehicle: {
          name: "Test Vehicle",
          license_plate: "ABC123",
          vehicle_type: "taxi",
          status: "active",
        } }

      expect(response).to redirect_to(vehicles_path(status: 'active'))
      expect(flash[:success]).to eq("Vehículo creado exitosamente")
    end
  end

  describe "PUT #update" do
    it "returns a success response" do
      put :update, params: { id: vehicle.id, vehicle: { name: "Updated Vehicle" } }

      expect(response).to redirect_to(vehicles_path(status: 'active'))
      expect(flash[:success]).to eq("Vehículo actualizado exitosamente")
    end
  end

  describe "DELETE #destroy" do
    it "returns a success response" do
      delete :destroy, params: { id: vehicle.id }
      expect(response).to redirect_to(vehicles_path(status: 'active'))
      expect(flash[:alert]).to eq("Vehículo archivado exitosamente")
    end
  end
end
