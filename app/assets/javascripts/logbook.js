$(document).on("page:update", function() {
  if($("#logbook").length > 0) {
    load_select2_hide_search_box();
  }
});
