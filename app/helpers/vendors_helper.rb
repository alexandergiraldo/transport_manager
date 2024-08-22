module VendorsHelper
  def account_vendors
    if current_user.super_admin?
      Vendor.all
    elsif current_user.account_admin?
      Vendor.where(account_id: current_user.active_account.id).order(:name)
    else
      Vendor.none
    end
  end
end
