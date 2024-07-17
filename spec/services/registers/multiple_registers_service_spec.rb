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
      end
    end
  end
end