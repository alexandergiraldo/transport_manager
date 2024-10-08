require 'rails_helper'

RSpec.describe AccountsPayable, type: :model do
  describe "Associations" do
    it { should belong_to(:account) }
    it { should belong_to(:vehicle) }
    it { should belong_to(:vendor) }
  end

  describe "Validations" do
    it { should validate_presence_of(:name) }
  end

  describe "before save" do
    it "should set the balance due" do
      account = create(:account)
      vendor = create(:vendor, account: account)
      vehicle = create(:vehicle, account: account)

      accounts_payable = create(:accounts_payable, total_amount: 100, amount_paid: 50, vendor: vendor, vehicle: vehicle, account: account)
      expect(accounts_payable.balance_due).to eq(50)
    end
  end

  describe "AccountsPayable model" do
    let (:account) { create(:account) }
    let (:vendor) { create(:vendor, account: account) }
    let (:vehicle) { create(:vehicle, account: account) }

    describe "status" do
      it "should return the partial status" do
        accounts_payable = create(:accounts_payable, total_amount: 100, amount_paid: 50, vendor: vendor, vehicle: vehicle, account: account, payment_date: Time.current + 1.day)
        expect(accounts_payable.status).to eq('partial')
      end

      it "should return the overdue status" do
        accounts_payable = create(:accounts_payable, total_amount: 100, amount_paid: 50, vendor: vendor, vehicle: vehicle, account: account, payment_date: Time.current - 1.day)
        expect(accounts_payable.status).to eq('overdue')
      end

      it "should return the pending status" do
        accounts_payable = create(:accounts_payable, total_amount: 100, amount_paid: 0, vendor: vendor, vehicle: vehicle, account: account, payment_date: Time.current + 1.day)
        expect(accounts_payable.status).to eq('pending')
      end

      it "should return the paid status" do
        accounts_payable = create(:accounts_payable, total_amount: 100, amount_paid: 100, vendor: vendor, vehicle: vehicle, account: account, payment_date: Time.current + 1.day)
        expect(accounts_payable.status).to eq('paid')
      end
    end

    describe "#mark_as_paid" do
      it "should mark the accounts payable as paid" do
        accounts_payable = create(:accounts_payable, total_amount: 100, amount_paid: 50, vendor: vendor, vehicle: vehicle, account: account)
        accounts_payable.mark_as_paid
        expect(accounts_payable.status).to eq('paid')
      end
    end

    describe "#balance_due" do
      it "should return the balance due" do
        accounts_payable = create(:accounts_payable, total_amount: 100, amount_paid: 50, vendor: vendor, vehicle: vehicle, account: account)
        expect(accounts_payable.balance_due).to eq(50)
      end
    end
  end
end
