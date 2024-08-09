class MaintenancePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      elsif user.account_admin?
        scope.where(vehicle_id: user.all_vehicle_ids)
      else
        scope.where(vehicle_id: user.vehicle_ids)
      end
    end
  end

  def update?
    if user.super_admin?
      true
    elsif user.account_admin?
      user.all_vehicle_ids.include? record.vehicle_id
    else
      user.vehicle_ids.include? record.vehicle_id
    end
  end

  def create?
    return true if user.super_admin? || user.account_admin?
    false
  end
end
