/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};

/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {

/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId])
/******/ 			return installedModules[moduleId].exports;

/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			exports: {},
/******/ 			id: moduleId,
/******/ 			loaded: false
/******/ 		};

/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);

/******/ 		// Flag the module as loaded
/******/ 		module.loaded = true;

/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}


/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;

/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;

/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";

/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(0);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
/***/ function(module, exports, __webpack_require__) {

	var smoothScroll = __webpack_require__(1);

	(function (document) {

	  var Collapsible = {

	    /**
	     * Initialise the Collapse behaviour
	     * @param {array} elems - array of HTMLCollections representing collapsible elements
	     * @param {object} toggle - the element to be used as a toggle. If `null`, one is created
	     * @param {bool} collapsed - if `true`, panel is collapsed by default
	     */
	    init: function(elems, toggle, collapsed) {
	      for (var i = 0; i < elems.length; i++) {
	        var toggleElem = toggle ? toggle.item(i) : null;
	        this.initPanel(elems[i], collapsed);
	        this.initToggle(elems[i], toggleElem);
	      }
	    },

	    /**
	     * Initialise the collapsible panel by setting its ID & 'aria-expanded' attributes
	     * @param {object} elem - the containing DOMElement
	     * @param {bool} collapsed - if `true`, panel is collapsed by default
	     */
	    initPanel: function(elem, collapsed) {
	      var panelLabel = elem.dataset ? elem.dataset.label ? elem.dataset.label : elem.className : elem.className;

	      elem.id = panelLabel;

	      if (collapsed) {
	        elem.setAttribute('aria-expanded', 'false');
	      }
	    },

	    /**
	     * Create a toggle element, attach an event listener and insert it into the DOM
	     * @param {object} elem - containing element for collapsible nav
	     */
	    initToggle: function(elem, toggle) {
	      var panelLabel = elem.dataset ? elem.dataset.label ? elem.dataset.label : elem.className : elem.className,
	          toggleElem = toggle || document.createElement('button'),
	          self = this;

	      // console.log(panelLabel, toggle);
	      if (!toggle) {
	          toggleElem.textContent = elem.dataset.toggleLabel || 'Menu';
	      }
	      
	      toggleElem.setAttribute('aria-controls', panelLabel);
	      toggleElem.className = panelLabel + '-toggle';
	      toggleElem.targetElem = elem;
	      toggleElem.addEventListener('click', self.togglePanel);

	      if (!toggle) {
	        elem.parentNode.insertBefore(toggleElem, elem);
	      }

	    },

	    /**
	     * Toggles ARIA attribute on the nav element
	     * @param {event} event - the event that triggered the toggle
	     */
	    togglePanel: function(event) {
	      var toggle = event.target,
	          elem = event.target.targetElem,
	          expanded = elem.getAttribute('aria-expanded') === 'true';

	      event.preventDefault();

	      if (elem.hasAttribute('open')) {
	        elem.removeAttribute('open');
	      } else {
	        elem.setAttribute('open', '');
	      }

	      toggle.setAttribute('aria-expanded', expanded ? 'false' : 'true');
	      elem.setAttribute('aria-expanded', expanded ? 'false' : 'true');
	    }

	  };

	  // Kick of the JavaScript party when the DOM is ready
	  document.addEventListener('DOMContentLoaded', function() {
	    var navElements = document.querySelectorAll('.global-nav, .local-nav');
	    Collapsible.init(navElements, null, true);

	    var accordionElements = document.querySelectorAll('.accordion, details'),
	        accordionToggleElement = document.querySelectorAll('.accordion-button, summary');
	    Collapsible.init(accordionElements, accordionToggleElement, false);
	  });

	})(document);


	// This code is legacy as of v1.2
	// Marked for removal in v2.0
	$(document).ready(function () {
	    $('.js-accordion-trigger').bind('touchstart click', function (e) {

	        jQuery(this).parent().find('ul').slideToggle('fast');
	        jQuery(this).find(".chevron").toggleClass('top bottom');
	        // apply the toggle to the ul
	        jQuery(this).parent().toggleClass('is-expanded');

	        // https://www.w3.org/WAI/GL/wiki/Using_the_WAI-ARIA_aria-expanded_state_to_mark_expandable_and_collapsible_regions
	        if (jQuery(this).attr('aria-expanded') == 'false') { // region is collapsed
	            // update the aria-expanded attribute of the region
	            jQuery(this).attr('aria-expanded', 'true');
	            // move focus to the region
	            jQuery(this).find('ul').focus();
	            jQuery(this).find('span').text("Show menu");
	        }
	        else { // region is expanded
	            // update the aria-expanded attribute of the region
	            jQuery(this).attr('aria-expanded', 'false');
	            jQuery(this).find('span').text("Hide menu");
	        }

	        e.preventDefault();
	    });
	});


/***/ },
/* 1 */
/***/ function(module, exports, __webpack_require__) {

	var __WEBPACK_AMD_DEFINE_FACTORY__, __WEBPACK_AMD_DEFINE_RESULT__;(function (root, smoothScroll) {
	  'use strict';

	  // Support RequireJS and CommonJS/NodeJS module formats.
	  // Attach smoothScroll to the `window` when executed as a <script>.

	  // RequireJS
	  if (true) {
	    !(__WEBPACK_AMD_DEFINE_FACTORY__ = (smoothScroll), __WEBPACK_AMD_DEFINE_RESULT__ = (typeof __WEBPACK_AMD_DEFINE_FACTORY__ === 'function' ? (__WEBPACK_AMD_DEFINE_FACTORY__.call(exports, __webpack_require__, exports, module)) : __WEBPACK_AMD_DEFINE_FACTORY__), __WEBPACK_AMD_DEFINE_RESULT__ !== undefined && (module.exports = __WEBPACK_AMD_DEFINE_RESULT__));

	  // CommonJS
	  } else if (typeof exports === 'object' && typeof module === 'object') {
	    module.exports = smoothScroll();

	  } else {
	    root.smoothScroll = smoothScroll();
	  }

	})(this, function(){
	'use strict';

	// Do not initialize smoothScroll when running server side, handle it in client:
	if (typeof window !== 'object') return;

	// We do not want this script to be applied in browsers that do not support those
	// That means no smoothscroll on IE9 and below.
	if(document.querySelectorAll === void 0 || window.pageYOffset === void 0 || history.pushState === void 0) { return; }

	// Get the top position of an element in the document
	var getTop = function(element) {
	    // return value of html.getBoundingClientRect().top ... IE : 0, other browsers : -pageYOffset
	    if(element.nodeName === 'HTML') return -window.pageYOffset
	    return element.getBoundingClientRect().top + window.pageYOffset;
	}
	// ease in out function thanks to:
	// http://blog.greweb.fr/2012/02/bezier-curve-based-easing-functions-from-concept-to-implementation/
	var easeInOutCubic = function (t) { return t<.5 ? 4*t*t*t : (t-1)*(2*t-2)*(2*t-2)+1 }

	// calculate the scroll position we should be in
	// given the start and end point of the scroll
	// the time elapsed from the beginning of the scroll
	// and the total duration of the scroll (default 500ms)
	var position = function(start, end, elapsed, duration) {
	    if (elapsed > duration) return end;
	    return start + (end - start) * easeInOutCubic(elapsed / duration); // <-- you can change the easing funtion there
	    // return start + (end - start) * (elapsed / duration); // <-- this would give a linear scroll
	}

	// we use requestAnimationFrame to be called by the browser before every repaint
	// if the first argument is an element then scroll to the top of this element
	// if the first argument is numeric then scroll to this location
	// if the callback exist, it is called when the scrolling is finished
	// if context is set then scroll that element, else scroll window 
	var smoothScroll = function(el, duration, callback, context){
	    duration = duration || 500;
	    context = context || window;
	    var start = window.pageYOffset;

	    if (typeof el === 'number') {
	      var end = parseInt(el);
	    } else {
	      var end = getTop(el);
	    }

	    var clock = Date.now();
	    var requestAnimationFrame = window.requestAnimationFrame ||
	        window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame ||
	        function(fn){window.setTimeout(fn, 15);};

	    var step = function(){
	        var elapsed = Date.now() - clock;
	        if (context !== window) {
	        	context.scrollTop = position(start, end, elapsed, duration);
	        }
	        else {
	        	window.scroll(0, position(start, end, elapsed, duration));
	        }

	        if (elapsed > duration) {
	            if (typeof callback === 'function') {
	                callback(el);
	            }
	        } else {
	            requestAnimationFrame(step);
	        }
	    }
	    step();
	}

	var linkHandler = function(ev) {
	    ev.preventDefault();

	    if (location.hash !== this.hash) window.history.pushState(null, null, this.hash)
	    // using the history api to solve issue #1 - back doesn't work
	    // most browser don't update :target when the history api is used:
	    // THIS IS A BUG FROM THE BROWSERS.
	    // change the scrolling duration in this call
	    smoothScroll(document.getElementById(this.hash.substring(1)), 500, function(el) {
	        location.replace('#' + el.id)
	        // this will cause the :target to be activated.
	    });
	}

	// We look for all the internal links in the documents and attach the smoothscroll function
	document.addEventListener("DOMContentLoaded", function () {
	    var internal = document.querySelectorAll('a[href^="#"]:not([href="#"])'), a;
	    for(var i=internal.length; a=internal[--i];){
	        a.addEventListener("click", linkHandler, false);
	    }
	});

	// return smoothscroll API
	return smoothScroll;

	});


/***/ }
/******/ ]);;
// git version: 5b17dc5fa7ec6fac645acbc0d585927bea14ab9e
// created at: Tue Jul 19 2016 07:38:14 GMT+0000 (UTC)