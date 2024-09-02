class Payment < ApplicationRecord
  belongs_to :accounts_payable
  belongs_to :account
  belongs_to :register, optional: true

  validates :payment_date, :amount, :payment_method, presence: true

  enum payment_method: { bank_transfer: 0, cash: 1, card: 2, check: 3, other: 4 }
end
