class Driver < ApplicationRecord
  # Associations
  belongs_to :account
  has_many :savings

  # Validations
  validates :name, presence: {message: "no puede ser vacio"}
  validate do
    self.errors[:birthday] << "formato invalido" unless (self.birthday.blank? || DateTime.parse(self.birthday)) rescue false
  end

  # Scopes
  scope :by_date, -> { order('id ASC') }
  scope :by_name, -> { order('name ASC') }

  accepts_nested_attributes_for :savings, reject_if: :all_blank, allow_destroy: true
end
