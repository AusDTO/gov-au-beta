(function (document) {

  var CollapsibleNav = {

    /**
     * Initialise the Global Nav collapse behaviour
     * @param {array} elems - list of collapsible elements
     */
    init: function(elems) {
      for (var i = 0; i < elems.length; i++) {
        if (elems[i] !== null) {
          this.initPanel(elems[i]);
          this.initToggle(elems[i]);
        }
      }
    },

    /**
     * Initialise the collapsible panel by setting its ID & 'aria-expanded' attributes
     * @param {object} elem - the containing DOMElement
     */
    initPanel: function(elem) {
      var panelLabel = elem.dataset.label || elem.className;

      elem.id = panelLabel;
      elem.setAttribute('aria-expanded', 'false');
    },

    /**
     * Create a toggle element, attach an event listener and insert it into the DOM
     * @param {object} elem - containing element for collapsible nav
     */
    initToggle: function(elem) {
      var panelLabel = elem.dataset.label || elem.className,
          toggle = document.createElement('button'),
          self = this;

      toggle.setAttribute('aria-controls', panelLabel);
      toggle.className = panelLabel + '-toggle';
      toggle.textContent = elem.dataset.toggleLabel || 'Menu';
      toggle.targetElem = elem;
      toggle.addEventListener('click', self.togglePanel);

      elem.parentNode.insertBefore(toggle, elem);
    },

    /**
     * Toggles ARIA attribute on the nav element
     * @param {event} event - the event that triggered the toggle
     */
    togglePanel: function(event) {
      var toggle = event.target,
          elem = event.target.targetElem,
          expanded = elem.getAttribute('aria-expanded') === 'true';

      toggle.setAttribute('aria-expanded', expanded ? 'false' : 'true');
      elem.setAttribute('aria-expanded', expanded ? 'false' : 'true');
    }

  };

  // Kick of the JavaScript party when the DOM is ready
  document.addEventListener('DOMContentLoaded', function() {
    CollapsibleNav.init([
      document.getElementsByClassName('global-nav').item(0),
      document.getElementsByClassName('local-nav').item(0)
    ]);
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
;
// git version: 04221eaa23b105d39009250dccab4af446d54418
// created at: Tue Jul 12 2016 07:01:41 GMT+0000 (UTC)