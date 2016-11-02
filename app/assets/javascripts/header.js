
// https://github.com/AusDTO/gov-au-ui-kit/pull/435
//===============================
checkMedia = function(){
  //Returns which media-query is active
  //(Content is added to the body via CSS media queries)
  var size = window.getComputedStyle( document.body, ':after' ).getPropertyValue( 'content' ).replace( /"/g, '' );

  if( size == 'desktop' ) { return 'desktop'; }
  else if ( size == 'tablet' ) { return 'tablet'; }
  else { return 'mobile'; }
}


//Show and toggle the search-box
//===============================
var $searchToggle = $('.search-toggle');
var $searchBox = $('.search-toggle-box');

function searchShow(){
  $('.search-toggle').attr('title', 'hide search').text('hide search').addClass('search-close');
  $('.search-toggle-box').show(); //FIXME slideDown is conflicting with something else?
}
function searchHide(){
  $('.search-toggle').attr('title', 'show search').text('show search').removeClass('search-close');
  $('.search-toggle-box').hide(); //FIXME slideUp is conflicting with something else?
}

$(document).ready(function() {
  $('.search-toggle').click(function(){
    if ( $('.search-toggle-box').is(':visible') ){
      searchHide();
    } else {
      searchShow();
    }
    event.preventDefault();
  });
});

window.onresize = function(event) {
  var mediaSize = checkMedia();
  if ( mediaSize == "mobile" ) {
    searchHide();
  } else {
    searchShow();
  }
};
