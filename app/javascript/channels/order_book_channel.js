import consumer from "./consumer"

var order_book_channel;

$(document).on('turbolinks:load.order_books', function () {

  
  let security_id = $('#order_book').attr('data-security-id');
  if(security_id){

    console.log(`Creating channel to order_book:security_id:${security_id}`);
    order_book_channel = consumer.subscriptions.create({channel: "OrderBookChannel", "security_id": security_id}, {

      connected() {
        // Called when the subscription is ready for use on the server
        console.log(`Connected to order_book:security_id:${security_id}`);
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(entity) {
        console.log("Received data");
        console.log(entity);
        
        if($(`#order_book`).length && $('#order_book').attr('data-security-id') == entity.security_id) {
          
          if(entity.type == "order_book") {
            $(`#order_book_${entity.security_id}`).replaceWith(entity.html);
          }
          else if(entity.type == "trade") {
            this.processTrade(entity);
          }
        }
        else {
          console.log("Ignoring received order book");
        }

      },

      processTrade(trade, data) {
        $("#order_book #trade_table").prepend(trade.html);
      },


    });
  }

});



$(document).on('turbolinks:before-render', function() {
  //$(document).off('turbolinks:load.order_books');
  if(order_book_channel) {
    console.log(`Unsubscribing ${order_book_channel}`);
    order_book_channel.unsubscribe();
    order_book_channel = null;
  }
});
