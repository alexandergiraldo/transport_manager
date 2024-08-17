class VehiclePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      elsif user.account_admin?
        scope.where(account_id: user.account_id)
      else
        scope.where(id: user.vehicle_ids).active
      end
    end
  end

  def update?
    if user.super_admin?
      true
    elsif user.account_admin?
      record.account_id == user.account_id
    else
      user.vehicle_ids.include?(record.id)
    end
  end

  def create?
    return true if user.super_admin? || user.account_admin?
    false
  end

  def report?
    true
  end

  def show?
    return true if user.super_admin?
    return true if user.account_admin? && user.account_ids.include?(record.account_id)
    user.vehicle_ids.include?(record.id)
  end
end
