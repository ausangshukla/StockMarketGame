import consumer from "./consumer"


  $(document).on('turbolinks:load.trades', function () {

    console.log("Creating channel to the trade:user_id");

    let user_id = $('#current_user_id').attr('data-current-user-id');
    consumer.subscriptions.create({channel: "TradeChannel", "user_id": user_id}, {

      connected() {
        // Called when the subscription is ready for use on the server
        console.log(`Connected to the trade:user_id:${user_id}`);
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(trade) {
        console.log("Received trade");
        if($(`#all_trades`).length) {
          if($(`#all_trades #trade-${trade.id}`).length) {
            console.log("Replacing trade");
            console.log(trade);
            $(`#all_trades #trade-${trade.id}`).replaceWith(trade.html);
          } else {
            console.log("Appending trade");
            console.log(trade);
            $("#all_trades #trade_table").append(trade.html);
          }

          $(`#trade-${trade.id}`).effect("highlight", {color:'#BCFCDD'}, 3000);
        } else {
          console.log("Ignoring received trade");
        }

      }
    });

  });

  $(document).on('turbolinks:before-render', function() {
    $(document).off('turbolinks:load.trades');
  });