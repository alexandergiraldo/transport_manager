class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin?
        scope.all
      elsif user.account_admin?
        scope.where(account_id: user.active_account.id)
      end
    end
  end

  def index?
    return true if user.account_admin?
    false
  end

  def create?
    return true if user.account_admin?
    if user.account_admin?
      user.account_ids.include?(record.account_id)
    end
    false
  end

  def update?
    if user.super_admin?
      return true
    elsif user.account_admin?
      return record.account_ids.include?(user.active_account.id)
    end

    return false
  end

  def destroy?
    return true if user.super_admin?
    if user.account_admin?
      return (user.account_ids & record.account_ids).present?
    end

    return false
  end
end
