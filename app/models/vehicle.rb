class Vehicle < ApplicationRecord
  enum :status, [ :active, :archived ]
  enum :vehicle_type, [ :taxi, :truck ]

  # Associations
  belongs_to :account
  has_many :maintenances, dependent: :delete_all
  has_many :registers, dependent: :delete_all
  has_many :accounts_payables, dependent: :delete_all

  accepts_nested_attributes_for :maintenances, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :registers, reject_if: :all_blank, allow_destroy: true

  # Validations
  validates :license_plate, presence: true, uniqueness: {message: 'Ya existe'}

  # Storage
  has_one_attached :image

  #scopes
  scope :by_date, -> { order('id DESC') }
  scope :by_model_date , -> { order('model_date DESC') }

  def cars_icon
    taxi? ? :local_taxi : :local_shipping
  end

  def object
    self
  end
end
