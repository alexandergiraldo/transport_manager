module DocumentHelper
  def advance_responsible_options
    current_account.vehicles.active.pluck(:license_plate, :id) << ["Empresa", 0]
  end

  def options_for_balance_in_favor_of(selected)
    options_for_select(
      Document.balance_in_favor_ofs.map { |key, value|
        [I18n.t("balance_in_favor_of.#{key}"), Document.balance_in_favor_ofs.key(value)]
      },
      selected
    )
  end

  def advance_responsible_title(document)
    return unless document.advance_responsible
    return "Empresa" if document.advance_responsible == 0
    Vehicle.find_by_id(document.advance_responsible).license_plate
  end

  def balance_in_favor_driver(document)
    document.driver_balance? ? document.balance_in_favor : nil
  end

  def balance_in_favor_vehicle(document)
    document.vehicle_balance? ? document.balance_in_favor : nil
  end
end