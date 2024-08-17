module VehicleHelper
  def user_vehicles
    if current_user.super_admin?
      Vehicle.all
    elsif current_user.account_admin?
      Vehicle.where(account_id: current_user.active_account.id).active
    else
      Vehicle.where(id: current_user.vehicle_ids).active
    end
  end

  def category_options(maintenance = nil)
    types = current_vehicle.account.maintenance_types.by_name.map{|m| [m.name, m.id]}
    selected = maintenance.try(:category) || params.dig(:q, :maintenance_type_id_eq)
    types << [maintenance.category, maintenance.category] if maintenance && maintenance.category.to_i == 0

    options_for_select(types, selected)
  end

  def vehicle_image(vehicle, size = [200, 200])
    if vehicle.image.attached?
      return image_tag(url_for(vehicle.image.variant(resize_to_fit: size)))
    end

    if vehicle.taxi?
      image_tag('vehicles/taxi-logo.png')
    else
      image_tag('vehicles/truck-logo.png')
    end
  end
end
