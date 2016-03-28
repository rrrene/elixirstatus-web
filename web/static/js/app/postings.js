function previewPosting() {
  var url = $(this).data("preview-url");
  $.ajax(url, {
                "method": "GET",
                "data": {
                  "title": $("#posting_title").val(),
                  "text": $("#posting_text").val()
                },
                "success": onPreviewPosting
              });
}

function onPreviewPosting(html) {
  $('.js-post-preview-inject').html(html);
}

function loadPostingFormModule() {
  $("a[data-preview-url]").click(previewPosting);
}

function loadPostingIndexModule() {
  loadFrontpagePostingTracker();
}

function loadFrontpagePostingTracker() {
  var THRESHOLD = 2000;
  var already_viewed = {};
  var timeout_id = null;

  function recordImpressionFor(posting_uids) {
    var not_yet_viewed = posting_uids.filter(function(uid) {
      return !already_viewed[uid];
    });

    var context = "frontpage";

    if( not_yet_viewed.length > 0 ) {
      $.ajax("/api/postings", {"method": "POST", "data": {"context": context, "uids": not_yet_viewed.join(',')}});

      not_yet_viewed.forEach(function(uid, index) {
        already_viewed[uid] = true;
      });
    }
  }

  function nowLookingAt(posting_uids) {
    if( timeout_id ) clearTimeout(timeout_id);
    timeout_id = setTimeout(function() {
      recordImpressionFor(posting_uids);
    }, THRESHOLD);
  }

  function isElementInViewport(el) {
      if (typeof jQuery === "function" && el instanceof jQuery) el = el[0];

      var rect = el.getBoundingClientRect();
      return (
          rect.top >= 0 &&
          rect.left >= 0 &&
          rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) && /*or $(window).height() */
          rect.right <= (window.innerWidth || document.documentElement.clientWidth) /*or $(window).width() */
      );
  }

  var resizeScrollHandler = function(evt) {
    var all_posts = $(".post[data-posting-uid]");
    var visible_posts = [];
    all_posts.each(function(index, el) {
      if( isElementInViewport($(el)) ) {
        visible_posts.push($(el).data("posting-uid"));
      }
    });
    nowLookingAt(visible_posts);
  };

  //jQuery
  $(window).on('DOMContentLoaded load resize scroll', resizeScrollHandler);
}

if( $(".posts").length > 0 ) jQuery(loadPostingIndexModule);
if( $(".post--new, .post--edit").length > 0 ) jQuery(loadPostingFormModule);
