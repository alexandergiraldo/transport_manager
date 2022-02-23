class SavingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      else
        scope.where(driver_id: user.active_account.driver_ids)
      end
    end
  end

  def update?
    if user.super_admin?
      true
    elsif user.account_admin?
      user.active_account.driver_ids.include? record.driver_id
    else
      false
    end
  end

  def create?
    self.update?
  end
end