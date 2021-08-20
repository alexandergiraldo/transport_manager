class DocumentPolicy < ApplicationPolicy
    class Scope < Scope
      def resolve
        if user.super_admin?
          scope.all
        else
          scope.where(user_id: user.id)
        end
      end
    end

    def update?
      if user.super_admin?
        true
      elsif user.account_admin?
        record.vehicle.account_id == user.account_id
      else
        user.vehicle_ids.include?(record.vehicle_id)
      end
    end
  end