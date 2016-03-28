(function(document) {
  var toggle = document.querySelector('.sidebar-toggle');
  var sidebar = document.querySelector('#sidebar');
  var checkbox = document.querySelector('#sidebar-checkbox');
})(document);

jQuery(function($) {
  $("a[data-toggle]").click(function(evt) {
    evt.preventDefault();
    var selector = $(this).data("toggle");
    $(selector).toggle();
  });

  $("a[data-submit=parent]").click(function(evt) {
    evt.preventDefault();
    $(this).closest("form").submit();
  });

  $("a[data-confirm]").click(function(evt) {
    var message = $(this).data("confirm");
    var result = confirm(message);

    if( result ) {
      // pass
      return true;
    } else {
      evt.preventDefault();
      evt.stopPropagation();
      return false;
    }
  });

  function visited(clicked_link) {
    var url = clicked_link.attr("href");
    var posting_uid = clicked_link.closest(".post[data-posting-uid]").data("posting-uid");

    $.ajax("/api/external", {"method": "POST", "data": {"uid": posting_uid, "url": url}});
  }

  var SELECTOR = ".post__body a";
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
    //
  }, time);
}

autoSavingContent("#posting_text", 500);
autoSavingContent("#posting_title", 502);
$("input[type='submit']").click(function () { localStorage.clear() });

require("web/static/js/app/postings");
