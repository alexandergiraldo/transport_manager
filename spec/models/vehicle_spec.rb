require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe "Associations" do
    it { should belong_to(:account) }
    it { should have_many(:registers).dependent(:delete_all) }
    it { should have_many(:maintenances).dependent(:delete_all) }
  end

  describe "Validations" do
    it { should validate_presence_of(:license_plate) }
  end

  describe "Scopes" do
    it "should have a scope active" do
      expect(Vehicle.active).to eq(Vehicle.where(status: 'active'))
    end
  end
end
