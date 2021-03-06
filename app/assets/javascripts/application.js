// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require foundation
//= require turbolinks

//= require vendor/underscore
//= require vendor/underscore.strings
//= require vendor/backbone
//= require vendor/nprogress
//= require vendor/keymaster
//= require vendor/backbone_shortcuts
//= require vendor/smoothscroll
//= require vendor/opentip
//= require_tree ./vendor/rangy

//= require mustache

//= require wiki_app/wiki_app
//= require_tree ./wiki_app
//= require_tree .

$(function(){ $(document).foundation(); });

