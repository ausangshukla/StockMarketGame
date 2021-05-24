import consumer from "./consumer"

consumer.subscriptions.create("OrderBookChannel", {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected to the order book");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log("Received data");
    console.log(data);
  }
});
