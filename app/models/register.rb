class Register < ApplicationRecord
  attr_accessor :category, :maintainable

  enum register_type: [ :incoming, :outcoming ]

  # Associations
  belongs_to :vehicle
  belongs_to :user
  has_one :maintenance, dependent: :destroy

  # Validations
  validates :register_type, presence: true

  # Scopes
  scope :by_date, -> { order('event_date ASC') }

  # Delegations
  delegate :license_plate, to: :vehicle, prefix: true

  def self.search(params, paginate: true)
    query = self.includes(:vehicle).ransack(params[:q])
    query.result
  end

end
