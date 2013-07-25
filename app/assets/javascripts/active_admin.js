//= require jquery
//= require jquery_ujs
//= require redactor/redactor

$(document).ready(function() {
  $('#blog_content').redactor({
    iframe: true,
    css: '/custom_redactor.css',
  });
});
