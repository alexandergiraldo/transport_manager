class Vehicle < ApplicationRecord
  enum status: [ :active, :archived ]

  # Associations
  belongs_to :account
  has_many :maintenances, dependent: :delete_all
  has_many :registers, dependent: :delete_all

  accepts_nested_attributes_for :maintenances, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :registers, reject_if: :all_blank, allow_destroy: true

  # Validations
  validates :license_plate, presence: true

  #scopes
  scope :by_date, -> { order('id DESC') }

  def object
    self
  end
end
