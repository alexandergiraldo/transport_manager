Registers = (function () {
  function calculate_registers_totals() {
    var incoming_values = [];
    var outcoming_values = [];

    $('.register-row:visible').each(function () {
      var type = $(this).find('input[class*=register-type-js]:checked').val();
      var value = $(this).find('.register-value').val() || 0;

      if (type === '0' || type === 'incoming') {
        incoming_values.push(parseInt(value));
      }
      else {
        outcoming_values.push(parseInt(value));
      }
    });

    var incoming_sum = sum_values(incoming_values)
    var outcoming_sum = sum_values(outcoming_values)

    $('#registers-incoming').html('$' + to_currency(incoming_sum));
    $('#registers-outcoming').html('$' + to_currency(outcoming_sum));
    $('#registers-total').html('$' + to_currency((incoming_sum - outcoming_sum)));
  }

  function monitor_total_values() {
    $(document).on("change", '.register-value, .register-type-js', function (e) {
      if ($(e.currentTarget).hasClass('register-type-js') && !$(e.currentTarget).hasClass('no-default-value')) {
        register_type_default_values($(this));
      }
      calculate_registers_totals();
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

  function register_type_default_values(selector) {
    if (selector.val() == '0' || selector.val() == 'incoming') {
      selector.parents('tr').find(".register-description").val('ENTREGA DÍA Y NOCHE');
      selector.parents('tr').find(".register-value").val(166000);
    }
    else {
      selector.parents('tr').find(".register-description").val('');
      selector.parents('tr').find(".register-value").val('');
    }
  }

  return {
    calculate_registers_totals: function () {
      calculate_registers_totals();
    },
    init: function () {
      calculate_registers_totals();
      monitor_total_values();
    }
  }
})();

$(function () {
  Registers.init();
});

window.Registers = Registers