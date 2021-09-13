class AccountUser < ApplicationRecord
    # Associations
    belongs_to :account
    belongs_to :user
  end
