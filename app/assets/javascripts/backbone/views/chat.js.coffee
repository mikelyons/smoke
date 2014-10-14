SmokeApp.Views.chat = Backbone.View.extend _.extend({},
  initialize: (options) ->
    @mapId = options.mapId

    sub = faye.subscribe("/#{@mapId}-chat", (m) ->
      $('#chat').append "<p>#{m}</p>"
    )

  render: ->
    #do something


  postToChat: (message) ->
    faye.publish("/#{@mapId}-chat", "hello"); 
)
