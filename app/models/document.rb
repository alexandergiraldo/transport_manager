class Document < ApplicationRecord
    # Associations
    has_many :registers, -> { order(:created_at => :asc) }, dependent: :destroy
    belongs_to :vehicle
    belongs_to :user

    accepts_nested_attributes_for :registers, reject_if: :all_blank, allow_destroy: true

    # Validations
    validates :title, presence: true

    # Scopes
    scope :by_date, -> { order('event_date ASC') }

    def self.search(params, paginate: true)
      query = self.ransack(params[:q])
      query.result
    end
  end
