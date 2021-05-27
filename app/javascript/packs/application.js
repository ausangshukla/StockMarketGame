// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()


require("bootstrap");
require('jquery');
require('webpack-jquery-ui');
require('webpack-jquery-ui/effects');

require('webpack-jquery-ui/css');

import "../stylesheets/application";
document.addEventListener("turbolinks:load", function() {

})
require("trix")
require("@rails/actiontext")

Turbolinks.setProgressBarDelay(1000)