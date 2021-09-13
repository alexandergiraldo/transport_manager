class UtilsController < ApplicationController
  before_action :authenticate_user!

  def change_current_vehicle
    if params[:vehicle_id].present?
      session[:vehicle_id] = params[:vehicle_id]
    end
    redirect_to request.referer
  end

  def change_user_account
    @user = current_user

    if @user.account_ids.include?(params[:account_id].to_i)
      @user.update(account_id: params[:account_id])
      flash = {success: "Cambio de cuenta exitoso"}
    else
      flash = {alert: "Ha ocurrido un error"}
    end

    redirect_to request.referer, flash: flash
  end
end