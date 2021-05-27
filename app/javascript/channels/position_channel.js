import consumer from "./consumer"

  $(document).on('turbolinks:load.positions', function () {

    console.log("Creating channel to the position:user_id");

    let user_id = $('#current_user_id').attr('data-current-user-id');
    consumer.subscriptions.create({channel: "PositionChannel", "user_id": user_id}, {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log(`Connected to the position:user_id:${user_id}`);
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(data) {
        
        if($(`#position-${data.id}`).length) {
          console.log("Replacing data");
          console.log(data);
          $(`#position-${data.id}`).replaceWith(data.html);
        } else {
          console.log("Appending data");
          console.log(data);
          $("#position_table").append(data.html);
        }
      }
    });

  });

  $(document).on('turbolinks:before-render', function() {
    $(document).off('turbolinks:load.positions');
  });