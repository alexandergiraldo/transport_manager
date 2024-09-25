Maintenances = (function () {
  function cocoon_callbacks() {
    $('.container-fluid').on('cocoon:after-insert', function (e, insertedItem) {
      window.Application.init_sheet_inputs();
      window.Application.initNumberMask();
      fillRegisterDate(insertedItem);
      autoFillDate(insertedItem);
    });

    $('.container-fluid').on('cocoon:after-remove', function (e, insertedItem) {
      calculate_maintenances_totals();
      window.Registers.calculate_registers_totals();
      window.Savings.calculate_savings_totals();
    });
  }

  function toggle_category_select() {
    $(document).on("change", ".register-maintainable-checkbox .maintenance_check_box", function () {
      $(this).closest('td').find(".select-category").toggle();
    });

    $(document).on("change", ".maintenance_checkbox", function () {
      $(this).parent().next(".select-category").toggle();
    });
  }

  function toggle_payment_select() {
    $(document).on("change", ".register-payments .payment_check_box", function () {
      $(this).closest('td').find(".select-accounts-payable").toggle();
    });
  }

  function calculate_maintenances_totals() {
    var outcoming_values = [];
    $('.maintenance-row').each(function () {
      var value = $(this).find('.maintenance-value').val() || 0;
      outcoming_values.push(parseInt(value));
    });
    $('#maintenances-total').html('$' + sum_values(outcoming_values));
  }

  function monitor_maintenances_values() {
    $(document).on("change", '.maintenance-value', function () {
      calculate_maintenances_totals();
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

  function fillRegisterDate(insertedItem) {
    if ($(".apply-date-checkbox").is(':checked')) {
      var date = $('.date-origin').val();
      insertedItem.find(".fill-date").val(date);
    }
  }

  function autoFillDate(insertedItem) {
    if ($(".auto-fill-date").length > 0) {
      var numOfFields = $('.auto-fill-date').length
      var lastDate = $('.auto-fill-date')[numOfFields - 2].value;
      if (lastDate == "") return;

      var date = new Date(lastDate);
      date.setDate(date.getDate() + 1);

      var dd = date.getDate();
      var mm = date.getMonth() + 1;
      var yyyy = date.getFullYear();

      if (dd < 10) {
        dd = '0' + dd
      }
      if (mm < 10) {
        mm = '0' + mm
      }
      date = yyyy + '/' + mm + '/' + dd;

      insertedItem.find(".auto-fill-date").val(date);
    }
  }

  return {
    init: function () {
      cocoon_callbacks();
      toggle_category_select();
      monitor_maintenances_values();
      toggle_payment_select();
    }
  }
})();

$(function () {
  Maintenances.init();
});
