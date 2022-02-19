class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  enum role: [ :account_user, :account_admin, :super_admin ]

  # Associations
  has_many :account_users, class_name: "AccountUser"
  has_many :accounts, through: :account_users, dependent: :delete_all

  def active_account
    Account.find_by(id: account_id) || accounts.first
  end

  def all_vehicle_ids
    return vehicle_ids if account_user?
    Vehicle.where(account_id: self.account_ids).pluck(:id) + vehicle_ids
  end

  def default_vehicle
    if account_user?
      Vehicle.find_by_id(vehicle_ids.first)
    else
      active_account.vehicles.active.first
    end
  end
end
