class RegisterSketch < ApplicationRecord
  belongs_to :account
  has_many :preload_registers, -> { order(position: :asc) }, dependent: :delete_all

  accepts_nested_attributes_for :preload_registers, reject_if: :all_blank, allow_destroy: true

  # Validations
  validates :name, presence: true
end
