class Report
  def vehicle_utilities_by_year(vehicle_id, year = null)
    year = Time.zone.now.year unless year
    data = Register.select("value, register_type").
      where(vehicle_id: vehicle_id).
      where('extract(year from event_date) = ?', year).
      group(:register_type).
      sum(:value)

    {
      "Ingresos": data["incoming"],
      "Egresos": data["outcoming"]
    }
  end

  def vehicle_utilities_by_month(vehicle_id, year = null)
    year = Time.zone.now.year unless year
    Time.use_zone("UTC") {
      start_date = Date.new(year.to_i,1,1)
      end_date = Date.new(year.to_i,12,31)
      income = Register.incoming.where(vehicle_id: vehicle_id).group_by_month(:event_date, format: "%b", range: start_date..end_date).sum(:value)
      outcome = Register.outcoming.where(vehicle_id: vehicle_id).group_by_month(:event_date, format: "%b", range: start_date..end_date).sum(:value)
      return [
        {
          "name" => "Ingresos",
          "data" => income
        },
        {
          "name" => "Egresos",
          "data" => outcome
        }
      ]
    }
  end
end
