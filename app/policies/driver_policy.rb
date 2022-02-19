class DriverPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      else
        scope.where(account_id: user.active_account.id)
      end
    end
  end

  def update?
    if user.super_admin?
      true
    elsif user.account_admin?
      user.account_ids.include?(record.account_id)
    else
      false
    end
  end

  def create?
    self.update?
  end
end