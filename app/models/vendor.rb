class Vendor < ActiveRecord::Base
  belongs_to :account
  has_many :accounts_payables, dependent: :restrict_with_error

  validates :name, presence: true

  enum :account_type, { savings: 0, checking: 1 }

  scope :by_name, -> { order(:name) }
end
