import consumer from "./consumer"

$(document).on('turbolinks:load', function () {

  let user_id = $('#current_user_id').attr('data-current-user-id');
  consumer.subscriptions.create({channel: "TradeChannel", "user_id": user_id}, {
    connected() {
      // Called when the subscription is ready for use on the server
      console.log(`Connected to the trade:user_id:${user_id}`);
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      
      if($(`#trade-${data.id}`).length) {
        console.log("Replacing data");
        console.log(data);
        $(`#trade-${data.id}`).replaceWith(data.html);
      } else {
        console.log("Appending data");
        console.log(data);
        $("#trade_table").append(data.html);
      }
    }
  });

});