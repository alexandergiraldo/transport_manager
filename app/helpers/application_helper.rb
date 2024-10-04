module ApplicationHelper
  include Pagy::Frontend

  def render_select2_css
    '<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />'.html_safe
  end

  def render_date_picker
    '<link rel="stylesheet" type="text/css" href="https://cdn.jsdelivr.net/npm/daterangepicker/daterangepicker.css" />'.html_safe
  end

  def flash_class(level)
    case level.to_sym
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-danger"
      when :alert then "alert alert-danger"
    end
  end

  def format_date(date)
    return nil unless date.present?
    date.strftime('%d/%m/%Y')
  end

  def value_to_currency(value)
    return 0 if value.blank?
    number_to_currency(value, precision: 0, delimiter: '.')
  end

  def month_options
    [['Enero',1],
    ['Febrero',2],
    ['Marzo',3],
    ['Abril',4],
    ['Mayo',5],
    ['Junio',6],
    ['Julio',7],
    ['Agosto',8],
    ['Septiembre',9],
    ['Octubre',10],
    ['Noviembre',11],
    ['Diciembre',12]]
  end

  def drivers_list
    current_account.drivers.by_name.map{|d| [d.name.titleize, d.id]}
  end

  def taxi_settings_allowed
    current_vehicle&.taxi? && (current_user.super_admin? || current_user.account_admin?)
  end

  def menu_active(controller)
    controller_name == controller.to_s ? 'active' : ''
  end

  def date_control_prev_month
    min_date = Date.parse('2000-01-01')
    selected_date = params[:event_start] || Time.current.strftime('%Y-%m')

    date = Date.parse(selected_date+'-01')
    prev_month = date.prev_month < min_date ? min_date : date.prev_month

    request.env['PATH_INFO'] + "?event_start=#{prev_month.strftime('%Y-%m')}"
  end

  def date_control_next_month
    max_date = Time.current + 2.months
    selected_date = params[:event_start] || Time.current.strftime('%Y-%m')

    date = Date.parse(selected_date+'-01')
    next_month = date.next_month > max_date ? max_date : date.next_month

    request.env['PATH_INFO'] + "?event_start=#{next_month.strftime('%Y-%m')}"
  end
end
