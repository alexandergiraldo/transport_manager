require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:user) { create(:account_admin) }
  let!(:vehicle) { create(:taxi, account_id: user.account_id) }
  let!(:report) { Report.new(vehicle.id) }

  describe '#total_vehicle_utilities' do
    it 'returns the total vehicle utilities' do
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 100, register_type: 'incoming')
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 50, register_type: 'outcoming')

      expect(report.total_vehicle_utilities[:total]).to eq(50)
    end
  end

  describe '#vehicle_utilities_by_year' do
    it 'returns the vehicle utilities by year' do
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 100, register_type: 'incoming', event_date: Date.new(2020, 1, 1))
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 50, register_type: 'outcoming', event_date: Date.new(2020, 1, 1))
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 100, register_type: 'incoming', event_date: Date.new(2020, 1, 1))
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 50, register_type: 'outcoming', event_date: Date.new(2020, 1, 1))

      expect(report.vehicle_utilities_by_year(2020)).to eq({
        "Ingresos" => 200,
        "Egresos" => 100
      })
    end
  end

  describe '#vehicle_utilities_by_month' do
    it 'returns the vehicle utilities by month' do
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 100, register_type: 'incoming', event_date: Date.new(2020, 1, 1))
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 50, register_type: 'outcoming', event_date: Date.new(2020, 1, 1))

      expect(report.vehicle_utilities_by_month(2020)).to eq([
        {
          "name" => "Ingresos",
          "data" => {
            "Abr" => 0,
            "Agos" => 0,
            "Dic" => 0,
            "Ene" => 100,
            "Feb" => 0,
            "Jul" => 0,
            "Jun" => 0,
            "Mar" => 0,
            "May" => 0,
            "Nov" => 0,
            "Oct" => 0,
            "Sept" => 0
          }
        },
        {
          "name" => "Egresos",
          "data" => {
            "Abr" => 0,
            "Agos" => 0,
            "Dic" => 0,
            "Ene" => 50,
            "Feb" => 0,
            "Jul" => 0,
            "Jun" => 0,
            "Mar" => 0,
            "May" => 0,
            "Nov" => 0,
            "Oct" => 0,
            "Sept" => 0
          }
        }
      ])
    end
  end

  describe '#total_vehicle_utilities_by_month' do
    it 'returns the total vehicle utilities by month' do
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 100, register_type: 'incoming', event_date: Date.new(2020, 1, 1))
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 50, register_type: 'outcoming', event_date: Date.new(2020, 1, 1))
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 200, register_type: 'incoming', event_date: Date.new(2020, 1, 1))
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 50, register_type: 'outcoming', event_date: Date.new(2020, 1, 1))

      expect(report.total_vehicle_utilities_by_month(2020)).to eq([
        {
          "name" => "Total utilidades por mes",
          "data" => {
            "Abr" => 0,
            "Agos" => 0,
            "Dic" => 0,
            "Ene" => 200,
            "Feb" => 0,
            "Jul" => 0,
            "Jun" => 0,
            "Mar" => 0,
            "May" => 0,
            "Nov" => 0,
            "Oct" => 0,
            "Sept" => 0
          }
        }
      ])
    end
  end

  describe '#total_vehicle_utilities_data' do
    it 'returns the total vehicle utilities data' do
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 100, register_type: 'incoming', event_date: Date.new(2020, 1, 1))
      create(:register, vehicle_id: vehicle.id, user_id: user.id, value: 50, register_type: 'outcoming', event_date: Date.new(2020, 1, 1))

      expect(report.total_vehicle_utilities_data).to eq([
        {
          "name" => "Utilidades por Año",
          "data" => { "2020" => 50 }
        }
      ])
    end
  end
end
