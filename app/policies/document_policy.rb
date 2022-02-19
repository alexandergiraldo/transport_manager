class DocumentPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        if user.super_admin?
          scope.all
        elsif user.account_admin?
          scope.where(account_id: user.active_account.id)
        else
          scope.where(account_id: user.active_account.id, vehicle_id: user.vehicle_ids)
        end
      end
    end

    def update?
      if user.super_admin?
        true
      elsif user.account_admin?
        user.account_ids.include?(record.account_id)
      else
        user.vehicle_ids.include?(record.vehicle_id)
      end
    end

    def create?
      self.update?
    end
  end