(function(document) {
  var toggle = document.querySelector('.sidebar-toggle');
  var sidebar = document.querySelector('#sidebar');
  var checkbox = document.querySelector('#sidebar-checkbox');
})(document);

jQuery(function($) {
  function visited(clicked_link) {
    var url = clicked_link.attr("href");
    var posting_uid = clicked_link.closest(".post[data-posting-uid]").data("posting-uid");

    $.ajax("/api/external", {"method": "POST", "data": {"uid": posting_uid, "url": url}});
  }

  var SELECTOR = ".post-body a";
  $("body").on("mouseup", SELECTOR, function(event) {
    if( (event.which == 2) ) visited($(this));
  }).on("click", SELECTOR, function(event) {
    visited($(this));
  });
});
