require 'rails_helper'

RSpec.describe Document, type: :model do
  describe "Associations" do
    it { should have_many(:registers) }
    it { should belong_to(:vehicle) }
    it { should belong_to(:user) }
    it { should belong_to(:driver).optional }
  end

  describe "Validations" do
    it { should validate_presence_of(:title) }
  end
end
