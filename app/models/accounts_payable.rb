class AccountsPayable < ActiveRecord::Base
  PAID = 'paid'.freeze
  OVERDUE = 'overdue'.freeze
  PENDING = 'pending'.freeze
  PARTIAL = 'partial'.freeze

  belongs_to :vendor
  belongs_to :vehicle
  belongs_to :account

  validates :name, presence: true
  validates :recurring_type, presence: { message: 'Debe seleccionar un tipo de recurrencia' }

  before_save :set_balance_due

  enum recurring_type: { one_time: 0, daily: 1, weekly: 2, biweekly: 3, monthly: 4, yearly: 5 }

  delegate :name, to: :vendor, prefix: true, allow_nil: true

  def self.search(params, paginate: true)
    query = ransack(params[:q])
    query.result
  end

  def status
    if amount_paid.to_i >= total_amount.to_i
      PAID
    elsif payment_date < Time.current
      OVERDUE
    elsif amount_paid.to_i == 0
      PENDING
    elsif balance_due.to_i < total_amount.to_i
      PARTIAL
    end
  end

  def set_balance_due
    self.balance_due = total_amount.to_i - amount_paid.to_i
  end

  def mark_as_paid
    self.amount_paid = total_amount
    self.balance_due = 0
    save
  end
end
