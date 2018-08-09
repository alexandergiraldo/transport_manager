class DriverPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      elsif user.account_admin?
        scope.where(account_id: user.account_id)
      else
        scope.none
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
end