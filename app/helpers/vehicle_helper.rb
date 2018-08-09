module VehicleHelper
  def user_vehicles
    if current_user.super_admin?
      Vehicle.all
    elsif current_user.account_admin?
      Vehicle.where(account_id: current_user.account_id).active
    else
      Vehicle.where(id: current_user.vehicle_ids).active
    end
  end

  def category_options(maintenance)
    types = current_vehicle.account.maintenance_types.by_name.map{|m| [m.name, m.id]}
    types << [maintenance.category, maintenance.category] if maintenance.category.to_i == 0
    options_for_select(types, maintenance.category)
  end
end