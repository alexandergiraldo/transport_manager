module RegisterHelper
  def register_type_color(register_type)
    return '' if register_type.blank?

    register_type.eql?('outcoming') ? 'text-danger' : 'text-success'
  end

  def register_type_sign(register_type)
    return '' if register_type.blank?
    register_type.eql?('outcoming') ? '-' : '+'
  end

  def register_type_options
    [['Entrada',0],['Gasto', 1]]
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
end
