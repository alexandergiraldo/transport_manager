module ApplicationHelper
  include Pagy::Frontend

  def render_select2_css
    '<link href="https://cdnjs.cloudflare.com/ajax/libs/select2/4.0.6-rc.0/css/select2.min.css" rel="stylesheet" />'.html_safe
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
end
