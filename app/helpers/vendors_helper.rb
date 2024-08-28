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

  def options_for_account_type
    options_for_select(
      Vendor.account_types.map { |key, value|
        [I18n.t("account_types.#{key}"), Vendor.account_types.key(value)]
      },
      @vendor.account_type
    )
  end

  def vendor_account_type(vendor)
    I18n.t("account_types.#{vendor.account_type}")
  end
end
