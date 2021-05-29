import consumer from "./consumer"


$(document).on('turbolinks:load.securities', function () {

  console.log("Creating channel to the security");

  consumer.subscriptions.create("SecurityChannel", {
    connected() {
      console.log("Connected to security channel");
    },

    disconnected() {
      // Called when the subscription has been terminated by the server
    },

    received(data) {
      // Called when there's incoming data on the websocket for this channel
      console.log(data)
      let price_node = $(`#sec_price_${data.id}`);
      price_node.html(data.price);
      price_node.effect("highlight", {color:'#BCFCDD'}, 3000);
    }
  });

});



$(document).on('turbolinks:before-render', function() {
  $(document).off('turbolinks:load.securities');
});
