Maintenances = (function(){
  function cocoon_callbacks() {
    $('.container-fluid').on('cocoon:after-insert', function(e, insertedItem) {
      window.Application.init_sheet_inputs();
      insertedItem.find(".select-category").toggle();
    });

    $('.container-fluid').on('cocoon:after-remove', function(e, insertedItem) {
      calculate_maintenances_totals();
      window.Registers.calculate_registers_totals();
    });

  }

  function toggle_category_select(){
    $(".select-category").toggle();
    $(document).on("change", ".register-maintainable-checkbox .check_box", function() {
      $(this).parent().next(".select-category").toggle();
    });
  }

  function calculate_maintenances_totals() {
    var outcoming_values = [];
    $('.maintenance-row').each(function(index) {
      var value = $(this).find('.maintenance-value').val();
      outcoming_values.push(parseInt(value));
    });
    $('#maintenances-total').html('$'+sum_values(outcoming_values));
  }

  function monitor_maintenances_values(){
    $(document).on("change", '.maintenance-value', function() {
      calculate_maintenances_totals();
    });
  }

  function sum_values(values){
    if(values.length > 0){
      return values.reduce((a, b) => a + b)
    }
    else{
      return 0;
    }
  }

  return{
    init: function() {
      cocoon_callbacks();
      toggle_category_select();
      monitor_maintenances_values();
    }
  }
})();

$(function() {
  Maintenances.init();
});
