class PreloadRegisterPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      elsif user.account_admin?
        scope.where(account_id: user.active_account.id)
      else
        scope.none
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