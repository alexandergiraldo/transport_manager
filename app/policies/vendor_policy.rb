class VendorPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      elsif user.account_admin?
        scope.where(account_id: user.account_id)
      else
        scope.where(id: user.account_id)
      end
    end
  end

  def create?
    user.super_admin? || user.account_admin?
  end

  def update?
    return true if user.super_admin?
    if user.account_admin?
      user.account_ids.include?(record.account_id)
    else
      false
    end
  end

  def destroy?
    update?
  end

  def show?
    update?
  end
end
