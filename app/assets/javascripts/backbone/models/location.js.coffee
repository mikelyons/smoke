SmokeApp.Models.Location = Backbone.Model.extend _.extend({},
  
  initialize: (options) ->
    @coords = options.coords
    console.log(@coords)

)