




window.SmokeApp = _.extend
  Models: {}
  Collections: {}
  Routers: {}
  Views: {}
  Mixins: {}

  start: ->
    window.faye = new Faye.Client('http://localhost:9292/faye')

    new SmokeApp.Views.Map()

, Backbone.Events

# disable backbone's sync
Backbone.sync = ->
  false

$(document).ready ->
  SmokeApp.start()
