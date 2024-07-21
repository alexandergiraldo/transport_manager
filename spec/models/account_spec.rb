require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "Associations" do
    it { should have_many(:vehicles).dependent(:destroy) }
    it { should have_many(:drivers).dependent(:delete_all) }
    it { should have_many(:account_users) }
    it { should have_many(:users).through(:account_users).dependent(:delete_all) }
    it { should have_one(:global_setting).dependent(:destroy) }
  end
end
