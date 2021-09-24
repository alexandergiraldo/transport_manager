class Register < ApplicationRecord
  attr_accessor :category, :maintainable

  enum register_type: [ :incoming, :outcoming ]

  # Associations
  belongs_to :vehicle
  belongs_to :user
  belongs_to :document, optional: true
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


  def self.preload_registers(register_sketch)
    return unless register_sketch.present?
    registers = []

    register_sketch.preload_registers.each do |preload_register|
      register = Register.new
      register.description = preload_register.description
      register.register_type = preload_register.register_type
      register.value = preload_register.value
      register.notes = preload_register.notes
      registers << register
    end

    registers
  end
end
