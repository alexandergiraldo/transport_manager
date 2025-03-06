class ReportsController < ApplicationController
  before_action :authenticate_user!

  content_security_policy only: :index do |policy|
    policy.style_src :self, :unsafe_inline
  end

  def index
    vehicle_id = params[:id].present? ? params[:id] : current_vehicle.id
    @vehicle = Vehicle.find(vehicle_id)
    authorize @vehicle, :report?

    reports = Report.new(@vehicle.id)
    @all_reports = reports.all_reports(params[:year])
  end
end
