$(function() {
  var faye = new Faye.Client('http://localhost:9292/faye');
  faye.subscribe("/locations/new", function(data){
    data = data.replace('(', '');
    data = data.replace(')', '');
    dis = data.split(',');
    console.log(dis);
    var pos = new google.maps.LatLng(dis[0], dis[1]);

    var image = 'http://www.gravatar.com/avatar?s=16&d=identicon';
    var infowindow = new google.maps.Marker({
      position: pos,
      map: map,
      icon: image
    });
  });
});
