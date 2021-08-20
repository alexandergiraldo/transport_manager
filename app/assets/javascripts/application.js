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
//= require datepicker.js
//= require select2.min.js
//= require cocoon
//= require registers
//= require maintenances
//= require savings

//= require dom-factory/dist/dom-factory.js
//= require material-design-kit/dist/material-design-kit.js


Application = (function () {
  function init_datepicker() {
    $('.datepicker').datepicker({ format: 'yyyy/mm/dd' });
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

  return {
    init_sheet_inputs: function () {
      init_select2_inputs();
      init_datepicker();
    },
    init: function () {
      init_datepicker();
      init_select2_inputs();
      auto_submit();
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

// Connect button(s) to drawer(s)
var sidebarToggle = Array.prototype.slice.call(document.querySelectorAll('[data-toggle="sidebar"]'));

sidebarToggle.forEach(function (toggle) {
  toggle.addEventListener('click', function (e) {
    var selector = e.currentTarget.getAttribute('data-target') || '#default-drawer';
    console.log(selector);
    var drawer = document.querySelector(selector);
    if (drawer) {
      drawer.mdkDrawer.toggle()
    }
  })
})