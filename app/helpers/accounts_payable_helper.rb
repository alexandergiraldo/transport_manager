module AccountsPayableHelper
  def options_for_recurring_types
    options_for_select(
      AccountsPayable.recurring_types.map { |key, value|
        [I18n.t("recurring_types.#{key}"), AccountsPayable.recurring_types.key(value)]
      },
      @accounts_payable.recurring_type
    )
  end

  def accounts_payable_status(accounts_payable)
    I18n.t("accounts_payable.status.#{accounts_payable.status}")
  end

  def accounts_payable_status_badge(accounts_payable)
    case accounts_payable.status
    when 'paid'
      'badge-success'
    when 'overdue'
      'badge-danger'
    when 'pending'
      'badge-warning'
    when 'partial'
      'badge-info'
    end
  end
end
