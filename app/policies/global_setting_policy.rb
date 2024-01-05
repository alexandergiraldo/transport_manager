class GlobalSettingPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      if user.super_admin? || user.account_admin?
        scope.all
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
    end
  end
end
