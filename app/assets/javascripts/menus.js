$(document).ready(function() {
  var menuClass = 'menu--active';

  /* Editor dropdowns */
  $(".controls--contrast ul > li.dropdown > a").on('click', function(e) {
    var target = $(this).parent();
    if (target.hasClass(menuClass)) {
      target.removeClass(menuClass);
    } else {
      target.addClass(menuClass);
    }
    e.preventDefault();
    return false;
  });

  /* Click elsewhere closes the menu */
  $(document).on('click', function(e) {
    $(".controls--contrast ul li.dropdown").removeClass(menuClass);
  });
});
