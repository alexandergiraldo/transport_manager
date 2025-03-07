module ReportHelper
  def calculate_utility(vehicle_utilities)
    income = vehicle_utilities['Ingresos'] || 0
    outcome = vehicle_utilities['Egresos'] || 0
    value = income - outcome
    value_to_currency(value)
  end
end
