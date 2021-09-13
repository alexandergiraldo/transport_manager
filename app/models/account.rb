class Account < ApplicationRecord
  # Associations
  has_many :vehicles, dependent: :destroy
  has_many :drivers, dependent: :delete_all
  has_many :maintenance_types, dependent: :delete_all

  has_many :account_users
  has_many :users, through: :account_users, dependent: :delete_all

  # Callbacks
  after_create :init_maintenance_types

  def active_vehicle_ids
    self.vehicles.active.pluck(:id)
  end

  private

  def init_maintenance_types
    MaintenanceType::DEFAULT_TYPES.each do |m_type|
      self.maintenance_types.new(name: m_type).save
    end
  end
end
