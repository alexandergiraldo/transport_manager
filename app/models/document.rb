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

  enum :balance_in_favor_of, [ :driver_balance, :vehicle_balance ]

  def self.ransackable_attributes(auth_object = nil)
    ['title', 'event_date', 'vehicle_id', 'user_id', 'driver_id']
  end

  def self.search(params, paginate: true)
    query = self.ransack(params[:q])
    query.result
  end

  def pending_difference
    pending_company_amount_paid.to_f - pending_company_amount.to_f
  end

  def from_location_title
    if title.to_s.downcase.include?('viaje')
      return title.gsub(/viaje/i, '').strip.split(' ').first
    end
    title.to_s.split(' - ').first
  end

  def to_location_title
    if title.to_s.downcase.include?('viaje')
      return title.gsub(/viaje/i, '').strip.split(' ').last
    end
    title.to_s.split(' - ').last
  end
end
