class Document < ApplicationRecord
  attr_accessor :apply_date_to_registers

  # Associations
  has_many :registers, -> { order(:created_at => :asc) }, dependent: :destroy
  belongs_to :vehicle
  belongs_to :user
  belongs_to :driver, optional: true

  accepts_nested_attributes_for :registers, reject_if: :all_blank, allow_destroy: true

  # Validations
  validates :title, presence: true

  # Scopes
  scope :by_date, -> { order('event_date ASC') }

  enum balance_in_favor_of: [ :driver_balance, :vehicle_balance ]

  def self.search(params, paginate: true)
    query = self.ransack(params[:q])
    query.result
  end

  def pending_difference
    pending_company_amount_paid.to_f - pending_company_amount.to_f
  end
end
