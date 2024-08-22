class Vendor < ActiveRecord::Base
  belongs_to :account
  has_many :accounts_payables, dependent: :restrict_with_error

  validates :name, presence: true

  scope :by_name, -> { order(:name) }
end
