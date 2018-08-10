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

  return{
    init: function() {
      cocoon_callbacks();
      toggle_category_select();
      //monitor_maintenances_values();
    }
  }
})();

$(function() {
  Maintenances.init();
});
