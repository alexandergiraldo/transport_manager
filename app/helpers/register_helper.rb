module RegisterHelper
  def register_type_color(register_type)
    return '' if register_type.blank?

    register_type.eql?('outcoming') ? 'text-danger' : 'text-success'
  end

  def register_type_sign(register_type)
    return '' if register_type.blank?
    register_type.eql?('outcoming') ? '-' : '+'
  end

  def calculate_registers_totals(registers)
    totals = {}
    totals[:total_incoming] = registers.select{|r| r.incoming?}.map(&:value).sum
    totals[:total_outcoming] = registers.select{|r| r.outcoming?}.map(&:value).sum
    totals[:total] = totals[:total_incoming] - totals[:total_outcoming]
    totals
  end

  def register_total_color(value)
    value < 0 ? 'text-danger' : 'text-success'
  end

  def register_type_class(no_default_value = false)
    html_class = "register-type-js"
    html_class += " no-default-value" if no_default_value || @document.present?
    html_class
  end

  def get_register_uri(vehicle)
    if vehicle.taxi?
      new_register_path
    elsif vehicle.truck?
      new_document_path
    end
  end

  def options_for_vehicle_types
    options_for_select(
      Vehicle.vehicle_types.map { |key, value|
        [I18n.t("vehicle_types.#{key}"), Vehicle.vehicle_types.key(value)]
      },
      @vehicle.vehicle_type
    )
  end

  def document_card_state(document)
    document.id.to_s == params[:open_document] ? "show" : ""
  end

  def register_sketches_options
    RegisterSketch.where(account_id: current_account.id).pluck(:name, :id)
  end

  def driver_options
    current_account.drivers.collect {|d| [ d.name, d.id ] }
  end
end
