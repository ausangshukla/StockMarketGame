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
        entity.data = JSON.parse(entity.data);
        
        if($(`#order_book`).length && $('#order_book').attr('data-security-id') == entity.data.security_id) {
          // console.log(`Same security order book = ${entity.data.security_id}`);
          // We are on the order book page for the same security
          if(entity.type == "order") {
            this.processOrder(entity);
          } else if(entity.type == "trade") {
            this.processTrade(entity);
          } else if(entity.type == "order_book") {
            this.processOrderBook(entity);
          }
          
        }
        else {
          console.log("Ignoring received order 1");
        }

      },

      processTrade(trade, data) {
        $("#order_book #trade_table").prepend(trade.html);
      },

      processOrder(order) {
        let data = order.data;
        if(data.fill_status=='Filled' || data.status=='Cancelled') {
          $(`#order_book #order-${order.id}`).remove();
        } 
      },

      processOrderBook(order) {
          let data = order.data;

          if(data.price_type == "Limit") {

            if(data.side == 'B') {
              console.log("Replacing limit buys");
              $(`#limit_buys #order_table`).replaceWith(order.html);
            } else {
              console.log("Replacing limit sells");
              $(`#limit_sells #order_table`).replaceWith(order.html);
            }      

          } else if(data.price_type == "Market") {

            if(data.side == 'B') {
              console.log("Replacing market buys");
              $(`#market_buys #order_table`).replaceWith(order.html);
            } else {
              console.log("Replacing market sells");
              $(`#market_sells #order_table`).replaceWith(order.html);
            }      

          }
    
      },


      replaceOrAdd(div_name, order) {
        console.log(`Trying #${div_name} #order-${order.id}`);
        // If we are on the orders page
        if($(`#${div_name} #order-${order.id}`).length) {
          // If we already have this order
          console.log("Replacing order");
          $(`#${div_name} #order-${order.id}`).replaceWith(order.html);
        } else if($(`#${div_name} #order_table_body`).length) {
          // We need to add this order
          console.log("Appending order");
          $(`#${div_name} #order_table_body`).append(order.html);
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
