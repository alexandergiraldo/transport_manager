class AccountsPayable < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :vehicle
  belongs_to :account
  has_many :payments, dependent: :delete_all

  validates :name, presence: true
  validates :recurring_type, presence: { message: 'Debe seleccionar un tipo de recurrencia' }
  validates :start_date, presence: { message: 'Debe seleccionar una fecha de inicio' }

  before_save :set_status

  enum :recurring_type, { one_time: 0, daily: 1, weekly: 2, biweekly: 3, monthly: 4, yearly: 5 }
  enum :status, { pending: 0, paid: 1, partial: 2 }

  delegate :name, to: :vendor, prefix: true, allow_nil: true

  def self.search(params, paginate: true)
    query = ransack(params[:q])
    query.result
  end

  def mark_as_paid
    self.amount_paid = total_amount
    save
  end

  def balance_due
    total_amount.to_i - amount_paid.to_i
  end

  def overdue?
    return false if payment_date.blank?
    payment_date < Time.current
  end

  def status
    if overdue? && super != 'paid'
      'overdue'
    else
      super
    end
  end

  def add_payment(amount)
    self.amount_paid += amount
    save!
  end

  private

  def set_status
    if amount_paid.to_i >= total_amount.to_i
      self.status = AccountsPayable.statuses[:paid]
    elsif amount_paid.to_i == 0
      self.status = AccountsPayable.statuses[:pending]
    else
      self.status = AccountsPayable.statuses[:partial]
    end
  end
end
