require 'rails_helper'

RSpec.describe Vendor, type: :model do
  describe "Associations" do
    it { should belong_to(:account) }
    it { should have_many(:accounts_payables).dependent(:restrict_with_error) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
  end
end
