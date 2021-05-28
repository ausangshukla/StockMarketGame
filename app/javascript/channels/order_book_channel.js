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

      received(order) {
        console.log("Received data");
        let data = JSON.parse(order.data);
        
        if($(`#order_book`).length && $('#order_book').attr('data-security-id') == data.security_id) {
          console.log(`Same security order book = ${data.security_id}`);
        
          //We are on the order book page for the same security
          if(data.side == "B" && data.price_type == "Limit") {
            this.replaceOrAdd("limit_buys", order);
          }
          else if(data.side == "S" && data.price_type == "Limit") {
            this.replaceOrAdd("limit_sells", order);
          }
          else if(data.side == "B" && data.price_type == "Market") {
            this.replaceOrAdd("market_buys", order);
          }
          else if(data.side == "S" && data.price_type == "Market") {
            this.replaceOrAdd("market_sells", order);
          } else {
            console.log(`Unmatched order ${data.side} ${data.price_type}`);  
          }
        }
        else {
          console.log("Ignoring received order 1");
        }

      },

      replaceOrAdd(div_name, order) {
        console.log(`Trying #${div_name} #order-${order.id}`);
        // If we are on the orders page
        if($(`#${div_name} #order-${order.id}`).length) {
          // If we already have this order
          console.log("Replacing order");
          $(`#${div_name} #order-${order.id}`).replaceWith(order.html);
        } else if($(`#${div_name} #order_table`).length) {
          // We need to add this order
          console.log("Appending order");
          $(`#${div_name} #order_table`).append(order.html);
        } else {
          console.log("Ignoring received order 2");
        }
      }

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
