# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https:#github.com/sstephenson/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery_2
#= require jquery_ujs
#= require foundation
#= require jquery.turbolinks
#= require turbolinks
#= require nprogress
#= require nprogress-turbolinks
#= require rails_confirm_dialog
#= require jquery.scrollto
#= require jquery.embedly.min
#= require jquery.preview
#= require shares
#= require markitup
#= require markitup/sets/markdown/set

# Add error class to .avatar images if they fail to load
# See avatar.scss and _avatar.html.haml
#= require imagesloaded
#= require avatar.errors


$ ->
    flashCallback = ->
      $(".alert-box").fadeOut()
    $(".alert-box").bind 'click', (ev) =>
      $(".alert-box").fadeOut()
    setTimeout flashCallback, 3000
    
    

# # // Set up preview.
$("#url").preview key: "3f5f5238235c4d9896c4e6e596e74ed1"

# # // On submit add hidden inputs to the form.
$("form").on "submit", ->
  $(this).addInputs $("#url").data("preview")
  true
