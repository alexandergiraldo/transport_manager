class AccountsPayable < ActiveRecord::Base
  belongs_to :vendor
  belongs_to :vehicle
  belongs_to :account
end
