Registers = (function () {
  function calculate_registers_totals() {
    var incoming_values = [];
    var outcoming_values = [];

    $('.register-row:visible').each(function () {
      var type = $(this).find('input[class*=register-type-js]:checked').val();
      var value = $(this).find('.register-value').val().replace(/\D/g, '') || 0;

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
      selector.parents('tr').find(".register-value").val(window.settings?.day_fee || 0);
    }
    else {
      selector.parents('tr').find(".register-description").val('');
      selector.parents('tr').find(".register-value").val('');
    }
  }

  function applySameDate() {
    $(document).on("change", ".apply-date-checkbox", function () {
      if ($(this).is(':checked')) {
        var date = $('.date-origin').val();
        $(".fill-date").each(function () {
          $(this).val(date);
        });
      }
    })
  }

  function autocompleteDates() {
    $('.autocomplete-register-dates').on('click', function () {
      var date = $('tbody#registers tr:first-child').find('input.fill-date').val();
      if (date == "") {
        return
      }
      $('tbody#registers input.fill-date').each(function () {
        $(this).val(date);
        date = new Date(date);
        prev_date = new Date(date);
        date.setDate(date.getDate() + 1);

        if (date.getMonth() != prev_date.getMonth()) {
          var mm = prev_date.getMonth() + 1;
          var dd = prev_date.getDate();
          var yyyy = prev_date.getFullYear();
        } else {
          var mm = date.getMonth() + 1;
          var dd = date.getDate();
          var yyyy = date.getFullYear();
        }

        if (dd < 10) {
          dd = '0' + dd
        }
        if (mm < 10) {
          mm = '0' + mm
        }

        date = yyyy + '/' + mm + '/' + dd;
      });
    });
  }

  function selectRegisterItems() {
    $(document).on('click', '.select-registers', function () {
      var $this = $(this);
      var registerItems = $this.closest('table').find('.register-check-item');

      if($this.is(':checked')) {
        registerItems.prop('checked', true);
        $('.delete-registers').removeClass('d-none').addClass('d-block');
      } else {
        registerItems.prop('checked', false);
        $('.delete-registers').removeClass('d-block').addClass('d-none');
      }

      updateMultipleRegistersIds($this);
    });

    $(document).on('click', '.register-check-item', function () {
      var $this = $(this);

      if($this.is(':checked')) {
        $('.delete-registers').removeClass('d-none').addClass('d-block');
      } else {
        var registerItems = $this.closest('table').find('.register-check-item');
        var checkedItems = registerItems.filter(':checked');

        if(checkedItems.length == 0) {
          $('.delete-registers').removeClass('d-block').addClass('d-none');
        }
      }
      updateMultipleRegistersIds($this);
    });
  }

  function updateMultipleRegistersIds(checkItem) {
    var deleteLink = checkItem.closest('.registers-list').find('.remove-all-registers');
    var registerItems = deleteLink.closest('.delete-registers').siblings('table').find('.register-check-item');
    var checkedItems = registerItems.filter(':checked');

    var ids = [];

    checkedItems.each(function() {
      ids.push($(this).val());
    });

    var confirmMessage = deleteLink.data('confirm');
    var confirmMessageParts = confirmMessage.split(' ');
    var lastPart = confirmMessageParts[confirmMessageParts.length - 1];
    if (lastPart.match(/\d+/)) {
      confirmMessageParts[confirmMessageParts.length - 1] = ids.length;
      deleteLink.attr('data-confirm', confirmMessageParts.join(' ')  + ' registros');
    } else {
      deleteLink.attr('data-confirm', confirmMessage + ' ' + ids.length + ' registros');
    }

    var href = deleteLink.attr('href');
    var url = new URL(href, window.location.origin);
    url.searchParams.set('register_ids', ids.join(','));
    deleteLink.attr('href', url.toString());
  }

  return {
    calculate_registers_totals: function () {
      calculate_registers_totals();
    },
    init: function () {
      calculate_registers_totals();
      monitor_total_values();
      applySameDate();
      autocompleteDates();
      selectRegisterItems();
    }
  }
})();

$(function () {
  Registers.init();
});

function locationAutocomplete () {
  var fromLocation = document.getElementById('fromLocation');
  var toLocation = document.getElementById('toLocation');
  var result = document.getElementById('document_title');

  if (!fromLocation || !toLocation) {
    return;
  }

  function initializeAutocomplete(input, callback) {
    var options = {
      types: ['geocode'],
      componentRestrictions: { country: ['us', 'co'] },
      fields: ['address_components', 'geometry', 'icon', 'name']
    }
    var autocomplete = new google.maps.places.Autocomplete(input, options);

    autocomplete.addListener('place_changed', function () {
        const place = autocomplete.getPlace();
        if (place && place.address_components) {
            const city = place.address_components[0].long_name;
            const lat = place.geometry.location.lat();
            const lng = place.geometry.location.lng();
            callback(city, lat, lng);
        }
    });
  }

  function updateResult() {
    const origin = fromLocation.value.trim();
    const destination = toLocation.value.trim();
    result.value = `${origin} - ${destination}`;
  }

  function preventEnter(event) {
    if (event.key === 'Enter') {
        event.preventDefault();
    }
  }

  initializeAutocomplete(fromLocation, (city, lat, lng) => {
    fromLocation.value = city;
    $('#document_from_latitude').val(lat);
    $('#document_from_longitude').val(lng);
    updateResult();
  });

  initializeAutocomplete(toLocation, (city, lat, lng) => {
    toLocation.value = city;
    $('#document_to_latitude').val(lat);
    $('#document_to_longitude').val(lng);
    updateResult();
  });

  fromLocation.addEventListener('keypress', preventEnter);
  toLocation.addEventListener('keypress', preventEnter);
}

function initMap(coordinates) {
  if (typeof google === 'undefined' || typeof google.maps.Map === 'undefined') {
    setTimeout(function () {
      initMap(coordinates);
    }, 100);
    return;
  }

  markers = [];

  var map = new google.maps.Map(document.getElementById('map'), {
    zoom: 2,
    center: { lat: 0, lng: 0 }
  });

  coordinates.forEach(function (coordinate) {
    var marker = new google.maps.Marker({
      position: { lat: coordinate.lat, lng: coordinate.lng },
      map: map
    });
    markers.push(marker);
  });

  var bounds = new google.maps.LatLngBounds();
  markers.forEach(marker => bounds.extend(marker.getPosition()));
  map.fitBounds(bounds);
}


window.Registers = Registers
window.locationAutocomplete = locationAutocomplete
window.initMap = initMap