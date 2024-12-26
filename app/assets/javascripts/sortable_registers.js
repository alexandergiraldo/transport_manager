SortableRegisters = (function () {
  function sortRegisters() {
    const list = document.getElementById("sortable-list");

    const url = window.location.href;
    const id = url.substring(url.lastIndexOf('/') + 1);
    const urlFetch = `/register_sketches/${id}/update_registers`;

    if (list) {
      new Sortable(list, {
        onEnd: function (event) {
          const ids = [...list.children].map((item) => item.dataset.id);

          const response = fetch(urlFetch, {
            method: "PUT",
            headers: {
              "Content-Type": "application/json",
              "X-CSRF-Token": document.querySelector('[name="csrf-token"]').content,
            },
            body: JSON.stringify({ register_ids: ids }),
          });

          response.then((response) => {
            if (document.querySelector(".flash-messages")) {
              document.querySelector(".flash-messages").remove();
            }

            const message = document.createElement("div");

            if (response.ok) {
              message.classList.add("alert", "flash-messages", "alert-success");
              message.innerText = "Planilla Actualizada";
            } else {
              message.classList.add("alert", "flash-messages", "alert-danger");
              message.innerText = "Ocurrió un error al actualizar la planilla";
            }

            document.querySelector(".container-fluid").prepend(message);

            setTimeout(() => {
              $(".flash-messages").fadeOut(1000, function () {
                $(this).remove();
              });
            }, 2000);
          });
        },
      });
    }

  }

  return {
    init: function () {
      sortRegisters()
    }
  }
})();

$(function () {
  SortableRegisters.init();
});

window.SortableRegisters = SortableRegisters