require 'rails_helper'

RSpec.describe Payments::PaymentCreator, type: :service do
  let(:account) { create(:account) }
  let (:vehicle) { create(:vehicle, account:) }
  let (:vendor) { create(:vendor, account: account) }
  let(:accounts_payable) { create(:accounts_payable, account:, vehicle:, vendor:) }
  let(:payment_params) do
    {
      payment_date: Date.today,
      amount: 1000,
      payer_details: "John Doe",
      payment_method: "cash",
      notes: "Notes",
      accounts_payable_id: accounts_payable.id
    }
  end

  subject { Payments::PaymentCreator.new(payment_params, account) }

  describe "#call" do
    context "when params are valid" do
      it "creates a payment" do
        expect { subject.call }.to change { Payment.count }.by(1)
      end

      it "updates accounts payable amount paid" do
        expect { subject.call }.to change { accounts_payable.reload.amount_paid }.by(1000)
      end
    end

    context "when params are invalid" do
      let(:payment_params) { { payment_date: nil } }

      it "returns false" do
        expect(subject.call).to eq(false)
      end
    end

    context "when accounts payable raise an exception" do
      before do
        allow_any_instance_of(AccountsPayable).to receive(:save!).and_raise(ActiveRecord::RecordInvalid.new(accounts_payable))
      end

      it "returns false" do
        expect(subject.call).to eq(false)
      end
    end
  end
end
