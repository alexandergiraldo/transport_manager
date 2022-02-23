Savings = (function () {
  function calculate_savings_totals() {
    var incoming_values = [];

    $('.saving-row').each(function () {
      var value = $(this).find('.saving-value').val().replace(/\D/g, '') || 0;
      incoming_values.push(parseInt(value));
    });

    var incoming_sum = sum_values(incoming_values)

    $('#savings-total').html('$' + to_currency(incoming_sum));
  }

  function monitor_total_values() {
    $(document).on("change", '.saving-value', function (e) {
      calculate_savings_totals();
    });
  }

  function sum_values(values) {
    if (values.length > 0) {
      var sum = values.reduce(function (x, y) {
        return x + y;
      });
      return sum
    }
    else {
      return 0;
    }
  }

  function to_currency(number) {
    return (number).toLocaleString('es-CO');
  }

  function new_saving_buttton() {
    $('#add-savings-button').click(function (e) {
      e.preventDefault();
      var driver_id = $('#q_driver_id_eq').val();
      window.location.href = $(this).attr('href').replace('@', driver_id);
    });
  }

  return {
    calculate_savings_totals: function () {
      calculate_savings_totals();
    },
    init: function () {
      calculate_savings_totals();
      monitor_total_values();
      new_saving_buttton();
    }
  }
})();

$(function () {
  Savings.init();
});

window.Savings = Savings