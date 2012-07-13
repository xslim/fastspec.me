$ ->
  $("#feature_tag_list").select2({tags:$("#feature_tag_list").data('content')});
  $("a.lightbox").fancybox({
    helpers: {
      title: {
        type: 'inside'
      }
    }
  });