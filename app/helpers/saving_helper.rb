module SavingHelper
  def options_for_saving_status
    options_for_select(
      Saving.statuses.map { |key, value|
        [I18n.t("saving_status.#{key}"), value]
      },
      params.dig(:q, :status_eq)
    )
  end

  def saving_main_path(params = {})
    current_vehicle&.truck? ? savings_index2_path(params) : savings_path(params)
  end
end