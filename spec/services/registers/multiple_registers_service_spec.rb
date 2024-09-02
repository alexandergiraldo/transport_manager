require 'rails_helper'

RSpec.describe Registers::MultipleRegistersService, type: :service do
  let(:user) { create(:account_admin) }
  let(:vehicle) { create(:taxi, account_id: user.account_id) }
  let(:current_account) { user.active_account }
  let(:params) do
    {
      vehicle: {
        registers_attributes: {
          '0' => {
            description: "Description",
            event_date: Date.today,
            value: "10000",
            notes: "Notes",
            register_type: "incoming",
            vehicle_id: vehicle.id
          }
        }
      }
    }
  end

  subject { Registers::MultipleRegistersService.new(params, user, vehicle, current_account) }

  describe "#process" do
    context "when params are valid" do
      it "creates a register" do
        expect { subject.process }.to change { Register.count }.by(1)
      end

      context "and maintainable is present" do
        let(:params) do
          {
            vehicle: {
              registers_attributes: {
                '0' => {
                  description: "Description",
                  event_date: Date.today,
                  value: "10000",
                  notes: "Notes",
                  register_type: "outcoming",
                  vehicle_id: vehicle.id,
                  maintainable: "1",
                  category: "Oil change",
                }
              }
            }
          }
        end

        it "creates a maintenance" do
          expect { subject.process }.to change { Maintenance.count }.by(1)
        end
      end
    end

    context "when params are invalid" do
      let(:params) { { registers: [{}] } }

      it "does not create a register" do
        expect { subject.process }.not_to change { Register.count }
        expect(subject.errors).to include("Invalid parameters")
      end
    end

    context "when user is not authorized" do
      let(:user) { create(:account_user) }

      it "raises a Pundit::NotAuthorizedError" do
        expect(Pundit::NotAuthorizedError).to receive(:new).with("Not authorized")

        expect(subject.process).to be false
      end
    end

    context "when document is present" do
      let(:vehicle) { create(:truck, account_id: user.account_id) }
      let(:params) do
        {
          document: {
            title: "Title",
            load_value: "10000",
            driver_advance: "10000",
            company_advance: "10000",
            balance_in_favor: "10000",
            pending_company_amount: "10000",
            pending_company_amount_paid: "10000",
            retentions: "10000",
            registers_attributes: {
              '0' => {
                description: "Description",
                event_date: Date.today,
                value: "10000",
                notes: "Notes",
                register_type: "incoming",
                vehicle_id: vehicle.id
              }
            }
          }
        }
      end

      it "creates a document" do
        expect { subject.process }.to change { Document.count }.by(1)
      end
    end

    context "when payment is present" do
      let(:vendor) { create(:vendor, account_id: current_account.id) }
      let(:accounts_payable) { create(:accounts_payable, vendor_id: vendor.id, account_id: current_account.id, vehicle_id: vehicle.id) }
      let(:params) do
        {
          vehicle: {
            registers_attributes: {
              '0' => {
                description: "Description",
                event_date: Date.today,
                value: "10000",
                notes: "Notes",
                register_type: "outcoming",
                vehicle_id: vehicle.id,
                paymentable: "1",
                payment: accounts_payable.id
              }
            }
          }
        }
      end

      it "creates a payment" do
        expect { subject.process }.to change { Payment.count }.by(1)
      end
    end

    context "when payment is present and maintainable is present" do
      let(:vendor) { create(:vendor, account_id: current_account.id) }
      let(:accounts_payable) { create(:accounts_payable, vendor_id: vendor.id, account_id: current_account.id, vehicle_id: vehicle.id) }
      let(:params) do
        {
          vehicle: {
            registers_attributes: {
              '0' => {
                description: "Description",
                event_date: Date.today,
                value: "10000",
                notes: "Notes",
                register_type: "outcoming",
                vehicle_id: vehicle.id,
                paymentable: "1",
                payment: accounts_payable.id,
                maintainable: "1",
                category: "Oil change",
              }
            }
          }
        }
      end

      it "creates a payment and maintanance" do
        expect { subject.process }.to change { Payment.count }.by(1).and change { Maintenance.count }.by(1)
      end
    end
  end
end