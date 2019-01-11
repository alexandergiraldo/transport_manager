class SavingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      elsif user.account_admin?
        scope.where(driver_id: user.account.driver_ids)
      else
        scope.none
      end
    end
  end

  def update?
    if user.super_admin?
      true
    elsif user.account_admin?
      user.account.driver_ids.include? record.driver_id
    else
      false
    end
  end

  def create?
    self.update?
  end
end