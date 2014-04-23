#= require ../vendor/underscore
#= require ../vendor/backbone
#= require_self
#= require_tree ./views

window.SmokeApp = _.extend
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  Mixins: {}

  start: ->
    #do something
    new SmokeApp.Views.Map()

, Backbone.Events

# disable backbone's sync
Backbone.sync = ->
  false

$(document).ready ->
  SmokeApp.start()
