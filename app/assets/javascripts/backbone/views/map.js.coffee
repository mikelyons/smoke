SmokeApp.Views.Map = Backbone.View.extend _.extend({},

  initialize: (options = {}) ->
    _.bindAll @, 'centerDeviceOnMap'
    _.bindAll @, 'handleNoGeolocation'

    @render()

  render: ->
    @setUpGoogleMap()

  setUpGoogleMap: ->
    #do something
    mapOptions = 
      zoom: 13
      mapTypeId: google.maps.MapTypeId.ROADMAP

    @map = new google.maps.Map $("#map-canvas")[0], mapOptions

    @geoLocate()

  geoLocate: ->
    if navigator.geolocation
      options =
        enableHighAccuracy: true,
        timeout: 5000,
        maximumAge: 0
      navigator.geolocation.getCurrentPosition(@centerDeviceOnMap, @handleNoGeolocation)
    else
      @handleNoGeolocation(false)

  addLocationToMap: ->
    #do something

  saveMapToRedis: ->
    # this concern should be in the model

    # mapId = window.location.pathname.replace('/', '')
    # $.post('http://localhost:9292/faye', 'message={"channel":"/locations/new", "data":"'+pos+'"}');

    $.post('http://localhost:3000/'+mapId+'/update_my_location', 
      {"location":pos.toString()}
    );

  centerDeviceOnMap: (position) ->
    @devicePosition = position 
    positionLatLng = new google.maps.LatLng(
      position.coords.latitude,
      position.coords.longitude
    )
    @map.setCenter(positionLatLng)

  handleNoGeolocation: (errorFlag) ->
    if errorFlag
      content = 'Error: The Geolocation service failed.'
    else
      content = 'Error: Your browser doesn\'t support geolocation.'

    alert content

    options = 
      map: @map
      position: new google.maps.LatLng(60, 105)
      content: content

    infowindow = new google.maps.InfoWindow(options);
    @map.setCenter(options.position);
)
