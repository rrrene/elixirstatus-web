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

function autoSavingContent(element, time) {
  var domElement = $(element);

  if (localStorage) {
    var content = localStorage.getItem("autoSave" + element);
    if (content) {
      domElement.val(content);
    }
  }

  domElement.autoSave(element, function ( ) {
    console.log("Autosaving... ", element);
  }, time);
}

autoSavingContent("#posting_text", 500);
autoSavingContent("#posting_title", 502);
$("input[type='submit']").click(function () { localStorage.clear() });


require("web/static/js/postings");
