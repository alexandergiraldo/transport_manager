class GlobalSettingsController < ApplicationController
  before_action :authenticate_user!

  def index
    @global_settings = policy_scope(GlobalSetting).where(account_id: current_account.id).first
  end

  def update
    @global_settings = GlobalSetting.find(params[:id])
    authorize @global_settings, :update?

    if @global_settings.update(global_settings_params)
      redirect_to global_settings_path, flash: {success: "Cambios aplicados exitosamente"}
    else
      flash.now[:error] = "Ha ocurrido un error"
      render :index
    end
  end

  def global_settings_params
    g_params = params.require(:global_setting).permit(:account_id, :day_fee)
    g_params[:day_fee] = Register.sanitize_amount(g_params[:day_fee])
    g_params
  end
end
