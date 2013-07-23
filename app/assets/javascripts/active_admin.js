//= require jquery
//= require jquery_ujs
//= require preload_ckeditor
//= require ckeditor/ckeditor

$(document).ready(function() {
  if ($("#blog_content").length) {
    CKEDITOR.replace('blog[content]', {height:"350"});
  }
});
