SmokeApp.Views.Map = Backbone.View.extend _.extend({},

  initialize: (options = {}) ->
    _.bindAll @, 'centerDeviceOnMap'
    _.bindAll @, 'handleNoGeolocation'

    @mapId = window.location.pathname.replace '/',''
    sub = faye.subscribe("/#{@mapId}", (m) ->
      $('#debug').append "<p>#{m}</p>"
    )

    new SmokeApp.Views.chat({mapId: @mapId})

    mapOptions =
      zoom: 13
      mapTypeId: google.maps.MapTypeId.ROADMAP
    @map = new google.maps.Map $("#map-canvas")[0], mapOptions

    @render()

  render: ->
    #@devicePosition = @geoLocate()
    @geoLocate()
    @addTestLocations()
    setTimeout(() =>
      @centerDeviceOnMap(@devicePosition)
    , 3000)
    @subscribeToLocations()

  geoLocate: () ->
    @GeoMarker = new GeolocationMarker()
    @GeoMarker.setCircleOptions({fillColor: '#808080'})

    google.maps.event.addListenerOnce(@GeoMarker, 'position_changed', () ->
      @map.setCenter(@getPosition())
      @map.fitBounds(@getBounds())
    )

    google.maps.event.addListener(@GeoMarker, 'geolocation_error', (e) ->
     alert('There was an error obtaining your position. Message: ' + e.message)
    )
    @GeoMarker.setMap(@map);

    ###
    positionLatLng = {}
    if navigator.geolocation
      navigator.geolocation.getCurrentPosition(
        (position) ->
          positionLatLng = new google.maps.LatLng(
            position.coords.latitude,
            position.coords.longitude
          )
      )

    else
      @handleNoGeolocation(false)
      ###

  centerDeviceOnMap: (position) ->
    if @testLocations
      markers = @testLocations
      bounds = new google.maps.LatLngBounds()
      for marker in markers
        bounds.extend(marker.getPosition())

      @map.setCenter(bounds.getCenter())

      @map.fitBounds(bounds)

      # @map.setZoom(@map.getZoom()-1)
    else
      @map.setCenter(position)
      @addLocationToMap(position)


  addLocationToMap: (location) ->
    if location instanceof google.maps.LatLng()
      alert("OH SHIT")

    @myLocationMarker = new google.maps.Marker({
      map: @map,
      position: location,
      Title: 'username'
      icon: "/assets/icons/beachflag.png"
    });
    publication = faye.publish("/#{@mapId}", location)
    $('#debug').append "<p>#{location}</p>"


  addTestLocations: () ->
    @testLocations = []

    myLatlng1 = new google.maps.LatLng(47.65046146,-122.3296359);
    @testLocations[0] = new google.maps.Marker({
      map: @map,
      position: myLatlng1,
      Title: 'test location'
    })
    $('#debug').append "<p>Test Location 1: #{myLatlng1}</p>"

    myLatlng = new google.maps.LatLng(47.62046146,-122.3296359);
    @testLocations[1] = new google.maps.Marker({
      map: @map,
      position: myLatlng,
      Title: 'test location'
    })
    $('#debug').append "<p>Test Location 2: #{myLatlng}</p>"

    @testLocations[2] = @GeoMarker

  subscribeToLocations: ->
    @channel = "/#{@mapId}/locations/new"
    console.log @mapId

    faye.publish("/#{@mapId}-chat", "hello");
    publication = faye.publish("/#{@mapId}", "hello")
    #
    # The test locaitons need to publish themselves to faye
    # then get them and place on the map so you make a round
    # trip

    # subscription = faye.subscribe(
    #   # "/#{@mapId}/locations/new"
    #   "/*"
    #   (data)->
    #     console.log(data)
    #     $('#debug').append "<p>#{data}</p>"
    #     true
    # )
    # subscription.then ->
    #   console.log('Active')
    #   publication = faye.publish("/#{@mapId}/locations/new", {text: "hello"})

    #   publication.then(
    #     ->
    #       console.log('sent')
    #     (error) ->
    #       alert('There was a problem: ' + error.message);
    #   )



  saveMapToRedis: ->
    # this concern should be in the model

    # mapId = window.location.pathname.replace('/', '')
    # $.post('http://localhost:9292/faye', 'message={"channel":"/locations/new", "data":"'+pos+'"}');

    $.post('http://localhost:3000/'+mapId+'/update_my_location',
      {"location":pos.toString()}
    );

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
