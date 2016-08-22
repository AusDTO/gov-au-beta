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

//set breakpoint for accordions to collapse at
var width = 520;


//open every accordion on the page
function open_accordions() {
  var b = document.querySelectorAll("details");
  for (var i=0; i < b.length; i++) {
    b[i].setAttribute("aria-expanded", "true");
    b[i].setAttribute('open', '');
  }
}

//close every accordion on the page
function close_accordions() {
  var b = document.querySelectorAll("details");
  for (var i=0; i < b.length; i++) {
    b[i].setAttribute("aria-expanded", "false");
    b[i].removeAttribute("open", "");
  }
}

//detect screen width and close or open accordions appropriately
function resizeFn() {
  var accordion_containers = document.getElementsByClassName('accordion-group');
  if (window.innerWidth<width) {
    close_accordions();
    for (var i=0; i < accordion_containers.length; i++) {
      accordion_containers[i].classList.add('show-open');
    }
  } else {
    open_accordions();
    for (var i=0; i < accordion_containers.length; i++) {
      accordion_containers[i].classList.add('show-close');
    }
  }
}

//insert 'Open all' and 'Close all' buttons into the DOM
function toggle_accordions() {

  var x = document.querySelectorAll(".accordion-group");

  for (var i=0; i < x.length; i++) {

    //define attributes for our 'Open all' button
    var openButton = document.createElement("button"),
      openText = document.createTextNode("Open all");
    openButton.setAttribute('class', 'open-all-accordions');
    openButton.appendChild(openText);

    //define attributes for our 'Close all' button
    var closeButton = document.createElement("button"),
      closeText = document.createTextNode("Close all");
    closeButton.setAttribute('class', 'close-all-accordions');
    closeButton.appendChild(closeText);

    //insert 'Open all' and 'Close all' buttons iside every '.accordion-group' container on the page
    x[i].insertBefore(openButton, x[i].childNodes[0])
    x[i].insertBefore(closeButton, x[i].childNodes[0])
  }

  //make the 'Open all' button open all accordions within it's parent section
  var openAll = document.getElementsByClassName('open-all-accordions');

  for (var i = 0; i < openAll.length; i++) {
    openAll[i].addEventListener('click',open_accordion_group,false);
  }

  function open_accordion_group(e){
    e.preventDefault();

    var c = this.parentNode.classList
    c.add('show-close')
    c.remove('show-open');

    var b = this.parentNode.querySelectorAll('details');

    for (var i=0; i < b.length; i++) {
      b[i].setAttribute("aria-expanded", "true");
      b[i].setAttribute('open', '');
    }
  }

  //make the 'Close all' button close all accordions within it's parent section
  var closeAll = document.getElementsByClassName('close-all-accordions');

  for (var i = 0; i < closeAll.length; i++) {
    closeAll[i].addEventListener('click',close_accordion_group,false);
  }

  function close_accordion_group(e){
    e.preventDefault();

    var c = this.parentNode.classList
    c.add('show-open')
    c.remove('show-close');

    var b = this.parentNode.querySelectorAll('details');

    for (var i=0; i < b.length; i++) {
      b[i].setAttribute("aria-expanded", "false");
      b[i].removeAttribute('open', '');
    }
  }
}

//toggles visiblity of open all and close all buttons
function find_accordion(){

  var accordions = document.querySelectorAll("details");

  for (var i=0; i < accordions.length; i++) {
    var accordion = accordions[i];

    //when user clicks an accordion we check whether we should hide or show open all or collapse all buttons
    accordion.onclick = function() {
      var b = this.parentNode.querySelectorAll('details');
      var open_count = 0,
        close_count = 0;
      for (var i=0; i < b.length; i++) {
        if (b[i].hasAttribute("open")) {
          var open_count = open_count + 1;
        }
        else {
          var close_count = close_count + 1;
        }
      }

      //toggle visibility class
      var c = this.parentNode;

      if (open_count > 0) {
        c.classList.add('show-close');
      } else {
        c.classList.remove('show-close');
      }
      if (close_count > 0) {
        c.classList.add('show-open');
      } else {
        c.classList.remove('show-open');
      }
    }
  }
}

window.onload = function() {
  resizeFn();
  toggle_accordions();
  find_accordion();
}
