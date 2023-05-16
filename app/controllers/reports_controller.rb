class ReportsController < ApplicationController
  def index
    reports = Report.new
    @vehicle_utilities_by_year = reports.vehicle_utilities_by_year(current_vehicle.id, params[:year])
    @vehicle_utilities_by_month = reports.vehicle_utilities_by_month(current_vehicle.id, params[:year])
    @total_vehicle_utilities = reports.total_vehicle_utilities(current_vehicle.id)
    @total_vehicle_utilities_by_month = reports.total_vehicle_utilities_by_month(current_vehicle.id, params[:year])
  end
end
