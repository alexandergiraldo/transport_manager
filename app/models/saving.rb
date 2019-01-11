class Saving < ApplicationRecord
  belongs_to :driver

  # Scopes
  scope :by_date, -> { order('event_date ASC') }

  def self.search(params, paginate: true)
    query = self.ransack(params[:q])
    query.result
  end
end
