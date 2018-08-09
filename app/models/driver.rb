class Driver < ApplicationRecord
  # Associations
  belongs_to :account

  # Validations
  validates :name, presence: {message: "no puede ser vacio"}
  validate do
    self.errors[:birthday] << "formato invalido" unless (self.birthday.blank? || DateTime.parse(self.birthday)) rescue false
  end

  # Scopes
  scope :by_date, -> { order('id DESC') }
end
