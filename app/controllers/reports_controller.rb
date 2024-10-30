class ReportsController < ApplicationController
  before_action :authenticate_user!

  content_security_policy only: :index do |policy|
    policy.style_src :self, :unsafe_inline
  end

  def index
    vehicle_id = params[:id].present? ? params[:id] : current_vehicle.id
    @vehicle = Vehicle.find(vehicle_id)
    authorize @vehicle, :report?
    reports = Report.new
    @vehicle_utilities_by_year = reports.vehicle_utilities_by_year(vehicle_id, params[:year])
    @vehicle_utilities_by_month = reports.vehicle_utilities_by_month(vehicle_id, params[:year])
    @total_vehicle_utilities = reports.total_vehicle_utilities(vehicle_id)
    @total_vehicle_utilities_by_month = reports.total_vehicle_utilities_by_month(vehicle_id, params[:year])
    @total_vehicle_utilities_data = reports.total_vehicle_utilities_data(vehicle_id)
  end
end
