class ApplicationController < ActionController::Base
  include Pundit::Authorization
  around_action :app_time_zone, if: :current_user
  before_action :validate_vehicle, if: :current_user
  helper_method :current_vehicle, :current_account, :current_settings

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def app_time_zone(&block)
    Time.use_zone("America/Bogota", &block)
  end

  def current_vehicle
    @current_vehicle ||= policy_scope(Vehicle).find_by_id(session[:vehicle_id]) || current_user.default_vehicle
  end

  def current_account
    @current_account ||= current_user.active_account || current_vehicle.try(:account)
  end

  def current_account_id
    current_account.id
  end

  def current_settings
    @current_settings ||= current_user ? current_account.global_setting : nil
  end

  protected

  def init_date_params
    if params[:event_start].present?
      year = params[:event_start].split('-').first.to_i
      month = params[:event_start].split('-').last.to_i
      date = Date.new(year, month, 1)
      params[:q] ||= {}
      params[:q][:event_date_gteq] = date
      params[:q][:event_date_lteq] = date.end_of_month
    else
      params[:q] = {event_date_gteq: Time.now.beginning_of_month, event_date_lteq: Time.now.end_of_month, driver_id_eq: params.dig(:q, :driver_id_eq)}
    end
  end

  def validate_vehicle
    unless current_vehicle.present?
      redirect_to new_vehicle_path if controller_name != 'vehicles' && action_name != 'change_user_account'
    end
  end

  def user_not_authorized
    flash[:alert] = "No tienes permisos para realizar esta acción. Si crees que es un error, por favor contacta al administrador."
    redirect_to(request.referrer || root_path)
  end
end
