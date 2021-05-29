import consumer from "./consumer"

  $(document).on('turbolinks:load.orders', function () {

    console.log("Creating channel to the order:user_id");

    let user_id = $('#current_user_id').attr('data-current-user-id');
    consumer.subscriptions.create({channel: "OrderChannel", "user_id": user_id}, {
      connected() {
        // Called when the subscription is ready for use on the server
        console.log(`Connected to the order:user_id:${user_id}`);
      },

      disconnected() {
        // Called when the subscription has been terminated by the server
      },

      received(order) {
        console.log("Received order");        
        let data = JSON.parse(order.data);
        
        if($(`#all_orders`).length) {
          this.replaceOrAdd("all_orders", order);
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
        } else if($(`#${div_name} #order_table_body`).length) {
          // We need to add this order
          console.log("Appending order");
          $(`#${div_name} #order_table_body`).append(order.html);
        } else {
          console.log("Ignoring received order 2");
        }

        $(`#${div_name} #order-${order.id}`).effect("highlight", {color:'#BCFCDD'}, 3000);
      }
    });

  });

  $(document).on('turbolinks:before-render', function() {
    $(document).off('turbolinks:load.orders');
  });