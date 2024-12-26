class PreloadRegister < ApplicationRecord
  acts_as_list scope: :register_sketch

  enum :register_type, [ :incoming, :outcoming ]

  belongs_to :account
  belongs_to :register_sketch

  # Validations
  validates :register_type, presence: true
end