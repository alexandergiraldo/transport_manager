class UtilsController < ApplicationController
  before_action :authenticate_user!

  def change_current_vehicle
    if params[:vehicle_id].present?
      session[:vehicle_id] = params[:vehicle_id]
    end
    redirect_to request.referer
  end
end