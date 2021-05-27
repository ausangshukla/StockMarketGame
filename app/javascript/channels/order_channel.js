import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  let user_id = $('#current_user_id').attr('data-current-user-id');
  consumer.subscriptions.create({channel: "OrderChannel", "user_id": user_id}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log(`Connected to the order:user_id:${user_id}`);
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      console.log("Received data");
      console.log(data);
      $(`#order-${data.id}`).replaceWith(data.html);
    }
  });

});