Registers = (function(){
  function calculate_registers_totals() {
    var incoming_values = [];
    var outcoming_values = [];

    $('.register-row').each(function() {
      var type = $(this).find('.register-type').val();
      var value = $(this).find('.register-value').val() || 0;

      if( type == '0'){
        incoming_values.push(parseInt(value));
      }
      else{
        outcoming_values.push(parseInt(value));
      }
    });

    var incoming_sum = sum_values(incoming_values)
    var outcoming_sum = sum_values(outcoming_values)

    $('#registers-incoming').html('$'+to_currency(incoming_sum));
    $('#registers-outcoming').html('$'+to_currency(outcoming_sum));
    $('#registers-total').html('$'+to_currency((incoming_sum-outcoming_sum)));
  }

  function monitor_total_values(){
    $(document).on("change", '.register-value, .register-type', function() {
      calculate_registers_totals();
    });
  }

  function sum_values(values){
    if(values.length > 0){
      var sum = values.reduce(function (x, y) {
        return x + y;
      });
      return sum
    }
    else{
      return 0;
    }
  }

  function to_currency(number){
    return (number).toLocaleString('es-CO');
  }

  return{
    calculate_registers_totals: function() {
      calculate_registers_totals();
    },
    init: function() {
      calculate_registers_totals();
      monitor_total_values();
    }
  }
})();

$(function() {
  Registers.init();
});

window.Registers = Registers