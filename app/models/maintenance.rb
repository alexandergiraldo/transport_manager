class Maintenance < ApplicationRecord
  attr_accessor :category, :registrable

  # Associations
  belongs_to :vehicle
  belongs_to :maintenance_type
  belongs_to :register, dependent: :destroy, optional: true

  # Scopes
  scope :by_date, -> { order('event_date ASC') }

  # Callbacks
  before_validation :process_category

  delegate :license_plate, to: :vehicle, prefix: true
  delegate :name, to: :maintenance_type, prefix: true

  def self.search(params, paginate: true)
    query = self.includes(:maintenance_type, :vehicle).ransack(params[:q])
    query.result
  end

  private

  def process_category
    return true if self.category.blank?
    if self.category.to_i != 0
      self.maintenance_type_id = self.category.to_i
    else
      maintenance_type = self.vehicle.account.maintenance_types.create(name: self.category.capitalize)
      self.maintenance_type_id = maintenance_type.id
    end
  end
end
