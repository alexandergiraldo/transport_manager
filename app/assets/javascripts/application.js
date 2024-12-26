// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require activestorage

//= require jquery/dist/jquery.min.js
//= require rails-ujs
//= require popper.js/dist/umd/popper.js
//= require bootstrap/dist/js/bootstrap.min.js
//= require imask/dist/imask.min.js
//= require sortablejs/Sortable.min.js
//= require datepicker.js
//= require select2.min.js
//= require moment.min.js
//= require daterangepicker.min.js
//= require cocoon
//= require chartkick
//= require Chart.bundle

//= require registers
//= require maintenances
//= require savings
//= require sortable_registers

//= require dom-factory/dist/dom-factory.js
//= require material-design-kit/dist/material-design-kit.js


Application = (function () {
  function init_datepicker() {
    $('.datepicker').datepicker({ format: 'yyyy/mm/dd' });
    $('#register-date').on('focus', function () {
      this.showPicker();
    });
    $('.daterange').daterangepicker({
      autoApply: true,
      locale: {
        format: 'YYYY/MM/DD',
      }
    });
  }

  function init_select2_inputs() {
    $('.category-select2').each(function (index) {
      $(this).attr('id', $(this).attr('id') + index)
      $(this).select2({
        width: '100%',
        tags: true
      });
    });
  }

  function auto_submit() {
    $(".auto-submit").change(function () {
      this.form.submit();
    });
  }

  function initNumberMask() {
    $(".imask_number").each(function () {
      IMask(this, {
        mask: Number,  // enable number mask
        scale: 0,
        signed: true,  // disallow negative
        thousandsSeparator: '.',  // any single char
        padFractionalZeros: false,  // if true, then pads zeros at end to the length of scale
        normalizeZeros: true,  // appends or removes zeros at ends
        radix: ',',  // fractional delimiter
      });
    });
  }

  return {
    init_sheet_inputs: function () {
      init_select2_inputs();
      init_datepicker();
    },
    init: function () {
      init_datepicker();
      init_select2_inputs();
      auto_submit();
      initNumberMask();
    },
    initNumberMask: function () {
      initNumberMask();
    }
  }
})();

window.Application = Application

$(function () {
  Application.init();
});

// Theme javascript
$('[data-toggle="tooltip"]').tooltip({ container: 'body' });
$('[data-toggle="popover"]').popover();

$('.dropdown.notifications ul a.nav-link').click(function (e) {
  e.stopPropagation();
  $(this).tab('show');
});

// Self Initialize DOM Factory Components
domFactory.handler.autoInit();

document.addEventListener('DOMContentLoaded', function () {
  // Connect button(s) to drawer(s)
  var sidebarToggle = Array.prototype.slice.call(document.querySelectorAll('[data-toggle="sidebar"]'));

  sidebarToggle.forEach(function (toggle) {
    toggle.addEventListener('click', function (e) {
      var selector = e.currentTarget.getAttribute('data-target') || '#default-drawer';
      var drawer = document.querySelector(selector);
      if (drawer) {
        drawer.mdkDrawer.toggle()
      }
    })
  })
});