class RegisterPolicy < MaintenancePolicy
  def create?
    if user.super_admin?
      true
    elsif user.account_admin?
      user.all_vehicle_ids.include?(record.vehicle_id)
    else
      user.vehicle_ids.include?(record.vehicle_id)
    end
  end

  def update?
    self.create?
  end
end
