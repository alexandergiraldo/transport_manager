class ApplicationController < ActionController::Base
  include Pundit::Authorization
  around_action :app_time_zone, if: :current_user
  before_action :validate_vehicle, if: :current_user
  helper_method :current_vehicle, :current_account

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

  protected

  def init_date_params
    if params.dig(:q, :event_date_gteq).present?
      year = params[:year].present? ? params[:year].to_i : Time.now.year
      date = Date.new(year, params.dig(:q, :event_date_gteq).to_i, 1)
      params[:q][:event_date_gteq] = date
      params[:q][:event_date_lteq] = date.end_of_month
    else
      params[:q] = {event_date_gteq: Time.now.beginning_of_month, event_date_lteq: Time.now.end_of_month, driver_id_eq: params.dig(:q, :driver_id_eq)}
    end
  end

  def validate_vehicle
    unless current_vehicle.present?
      redirect_to new_vehicle_path if controller_name != 'vehicles'
    end
  end

  def user_not_authorized
    flash[:alert] = "You are not authorized to perform this action."
    redirect_to(request.referrer || root_path)
  end
end
