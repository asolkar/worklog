// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
var entry_input_state = 0;
!function ($) {
$(function(){

  var $window = $(window)
  var entry_input_form_pos;

  //
  // Activate Bootstrap tooltips
  //
  $(".container-narrow").tooltip({
    selector: "a[rel~=tooltip]"
  });

  //
  // Dismiss alerts after 5 seconds
  //
  $('.alert').delay(5000).fadeOut(300);

  //
  // Control the Entry input field
  //
  $("#entry_input_form").hide();
  $("#entry_input_form_toggle i").click(function() {
    $("#entry_input_form").slideToggle("fast");
    $("textarea#entry_body").focus();
    if ($("#entry_input_form").is(':visible')) {
      entry_input_form_pos = $('#entry_input_form').position();
    }
  });
  $(window).scroll(function() {
    if ($("#entry_input_form").is(':visible')) {
      var window_top = $(window).scrollTop();
      if (window_top > entry_input_form_pos.top) {
        $("#entry_input_form").css('position', 'fixed');
        $("#entry_input_form").css('top', '0px');
      } else {
        $("#entry_input_form").css('position', 'relative');
      }
    }
  });

  //
  // Entry tag chooser
  //
  $('#entry_tags').chosen();

  //
  // Power the tag color picker
  //
  $('#tag_colorpicker').colorpicker();
})

}(window.jQuery)
