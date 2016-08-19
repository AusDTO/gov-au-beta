// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require "ui-kit"
//= require "cable"

function open_accordions() {
  var b = document.querySelectorAll("details");
  for (var i=0; i < b.length; i++) {
    b[i].setAttribute("aria-expanded", "true");
    b[i].setAttribute('open', '');
  }
}

function close_accordions() {
  var b = document.querySelectorAll("details");
  for (var i=0; i < b.length; i++) {
    b[i].setAttribute("aria-expanded", "false");
    b[i].removeAttribute("open", "");
  }
}

var widths = [0, 500];

function resizeFn() {
if (window.innerWidth>=widths[0] && window.innerWidth<widths[1]) {
close_accordions();
} else {
open_accordions();
}
}
window.onresize = resizeFn;
window.onload = resizeFn;
resizeFn();
