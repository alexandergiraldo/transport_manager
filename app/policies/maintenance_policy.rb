class MaintenancePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      elsif user.account_admin?
        scope.where(vehicle_id: user.account.active_vehicle_ids)
      else
        scope.where(vehicle_id: user.vehicle_ids & user.account.active_vehicle_ids)
      end
    end
  end

  def update?
    if user.super_admin?
      true
    elsif user.account_admin?
      user.account.active_vehicle_ids.include? record.vehicle_id
    else
      (user.vehicle_ids & user.account.active_vehicle_ids).include? record.vehicle_id
    end
  end
end
