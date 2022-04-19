class Saving < ApplicationRecord
  belongs_to :driver
  belongs_to :vehicle, optional: true

  enum status: [ :saved, :paid ]

  # Scopes
  scope :by_date, -> { order('event_date ASC') }
  scope :by_date_desc, -> { order('event_date DESC') }

  def self.search(params, paginate: true)
    query = self.ransack(params[:q])
    query.result
  end

  def self.sanitize_amount(amount)
    return amount&.delete('^0-9-')
  end
end
