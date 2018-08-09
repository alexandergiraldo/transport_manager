Maintenances = (function(){
  function cocoon_callbacks() {
    $('.container-fluid').on('cocoon:after-insert', function(e, insertedItem) {
      window.Application.init_sheet_inputs();
      insertedItem.find(".select-category").toggle();

      insertedItem.find(".register-maintainable-checkbox .check_box").on( "change", function() {
        $(this).parent().next(".select-category").toggle();
      });
    });
  }

  function toggle_category_select(){
    $(".select-category").toggle();
    $(".register-maintainable-checkbox .check_box").on( "change", function() {
      $(this).parent().next(".select-category").toggle();
    });
  }

  return{
    init: function() {
      cocoon_callbacks();
      toggle_category_select();
    }
  }
})();

$(function() {
  Maintenances.init();
});
