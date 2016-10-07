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
//= require menus
//= require "ui-kit"
//= require "cable"
//= require analytics.js

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
function screen_width_accordions() {
  var accordion_containers = document.getElementsByClassName('accordion-group');
  if (window.innerWidth<width) {
    close_accordions();
    for (var i=0; i < accordion_containers.length; i++) {
      accordion_containers[i].classList.add('disable-close-button');
    }
  } else {
    open_accordions();
    for (var i=0; i < accordion_containers.length; i++) {
      accordion_containers[i].classList.add('disable-open-button');
    }
  }
}

//insert 'Open all' and 'Close all' buttons into the DOM
function toggle_accordions_buttons() {

  var x = document.querySelectorAll(".accordion-group");

  for (var i=0; i < x.length; i++) {

    //define attributes for our 'Open all' button
    var openButton = document.createElement("button"),
      openText = document.createTextNode("Expand all");
    openButton.setAttribute('class', 'open-all-accordions');
    openButton.appendChild(openText);

    //define attributes for our 'Close all' button
    var closeButton = document.createElement("button"),
      closeText = document.createTextNode("Collapse all");
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
    c.add('disable-open-button')
    c.remove('disable-close-button');

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
    c.add('disable-close-button')
    c.remove('disable-open-button');

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
        c.classList.add('disable-open-button');
      } else {
        c.classList.remove('disable-open-button');
      }
      if (close_count > 0) {
        c.classList.add('disable-close-button');
      } else {
        c.classList.remove('disable-close-button');
      }
    }
  }
}

window.onload = function() {
  screen_width_accordions();
  toggle_accordions_buttons();
  find_accordion();
}



//TO DO find replacement for classList as it doesn't work with IE9 and below
// investigate if we could use className += " class"

//shim for classList to work in IE9 https://developer.mozilla.org/en/docs/Web/API/Element/classList
/*
 * classList.js: Cross-browser full element.classList implementation.
 * 2014-07-23
 *
 * By Eli Grey, http://eligrey.com
 * Public Domain.
 * NO WARRANTY EXPRESSED OR IMPLIED. USE AT YOUR OWN RISK.
 */

/*global self, document, DOMException */

/*! @source http://purl.eligrey.com/github/classList.js/blob/master/classList.js*/

if ("document" in self) {

// Full polyfill for browsers with no classList support
if (!("classList" in document.createElement("_"))) {

(function (view) {

"use strict";

if (!('Element' in view)) return;

var
    classListProp = "classList"
  , protoProp = "prototype"
  , elemCtrProto = view.Element[protoProp]
  , objCtr = Object
  , strTrim = String[protoProp].trim || function () {
    return this.replace(/^\s+|\s+$/g, "");
  }
  , arrIndexOf = Array[protoProp].indexOf || function (item) {
    var
        i = 0
      , len = this.length
    ;
    for (; i < len; i++) {
      if (i in this && this[i] === item) {
        return i;
      }
    }
    return -1;
  }
  // Vendors: please allow content code to instantiate DOMExceptions
  , DOMEx = function (type, message) {
    this.name = type;
    this.code = DOMException[type];
    this.message = message;
  }
  , checkTokenAndGetIndex = function (classList, token) {
    if (token === "") {
      throw new DOMEx(
          "SYNTAX_ERR"
        , "An invalid or illegal string was specified"
      );
    }
    if (/\s/.test(token)) {
      throw new DOMEx(
          "INVALID_CHARACTER_ERR"
        , "String contains an invalid character"
      );
    }
    return arrIndexOf.call(classList, token);
  }
  , ClassList = function (elem) {
    var
        trimmedClasses = strTrim.call(elem.getAttribute("class") || "")
      , classes = trimmedClasses ? trimmedClasses.split(/\s+/) : []
      , i = 0
      , len = classes.length
    ;
    for (; i < len; i++) {
      this.push(classes[i]);
    }
    this._updateClassName = function () {
      elem.setAttribute("class", this.toString());
    };
  }
  , classListProto = ClassList[protoProp] = []
  , classListGetter = function () {
    return new ClassList(this);
  }
;
// Most DOMException implementations don't allow calling DOMException's toString()
// on non-DOMExceptions. Error's toString() is sufficient here.
DOMEx[protoProp] = Error[protoProp];
classListProto.item = function (i) {
  return this[i] || null;
};
classListProto.contains = function (token) {
  token += "";
  return checkTokenAndGetIndex(this, token) !== -1;
};
classListProto.add = function () {
  var
      tokens = arguments
    , i = 0
    , l = tokens.length
    , token
    , updated = false
  ;
  do {
    token = tokens[i] + "";
    if (checkTokenAndGetIndex(this, token) === -1) {
      this.push(token);
      updated = true;
    }
  }
  while (++i < l);

  if (updated) {
    this._updateClassName();
  }
};
classListProto.remove = function () {
  var
      tokens = arguments
    , i = 0
    , l = tokens.length
    , token
    , updated = false
    , index
  ;
  do {
    token = tokens[i] + "";
    index = checkTokenAndGetIndex(this, token);
    while (index !== -1) {
      this.splice(index, 1);
      updated = true;
      index = checkTokenAndGetIndex(this, token);
    }
  }
  while (++i < l);

  if (updated) {
    this._updateClassName();
  }
};
classListProto.toggle = function (token, force) {
  token += "";

  var
      result = this.contains(token)
    , method = result ?
      force !== true && "remove"
    :
      force !== false && "add"
  ;

  if (method) {
    this[method](token);
  }

  if (force === true || force === false) {
    return force;
  } else {
    return !result;
  }
};
classListProto.toString = function () {
  return this.join(" ");
};

if (objCtr.defineProperty) {
  var classListPropDesc = {
      get: classListGetter
    , enumerable: true
    , configurable: true
  };
  try {
    objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
  } catch (ex) { // IE 8 doesn't support enumerable:true
    if (ex.number === -0x7FF5EC54) {
      classListPropDesc.enumerable = false;
      objCtr.defineProperty(elemCtrProto, classListProp, classListPropDesc);
    }
  }
} else if (objCtr[protoProp].__defineGetter__) {
  elemCtrProto.__defineGetter__(classListProp, classListGetter);
}

}(self));

} else {
// There is full or partial native classList support, so just check if we need
// to normalize the add/remove and toggle APIs.

(function () {
  "use strict";

  var testElement = document.createElement("_");

  testElement.classList.add("c1", "c2");

  // Polyfill for IE 10/11 and Firefox <26, where classList.add and
  // classList.remove exist but support only one argument at a time.
  if (!testElement.classList.contains("c2")) {
    var createMethod = function(method) {
      var original = DOMTokenList.prototype[method];

      DOMTokenList.prototype[method] = function(token) {
        var i, len = arguments.length;

        for (i = 0; i < len; i++) {
          token = arguments[i];
          original.call(this, token);
        }
      };
    };
    createMethod('add');
    createMethod('remove');
  }

  testElement.classList.toggle("c3", false);

  // Polyfill for IE 10 and Firefox <24, where classList.toggle does not
  // support the second argument.
  if (testElement.classList.contains("c3")) {
    var _toggle = DOMTokenList.prototype.toggle;

    DOMTokenList.prototype.toggle = function(token, force) {
      if (1 in arguments && !this.contains(token) === !force) {
        return force;
      } else {
        return _toggle.call(this, token);
      }
    };

  }

  testElement = null;
}());

}

}


