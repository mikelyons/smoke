$(function() {
  var faye = new Faye.Client('http://localhost:9292/faye');
  faye.subscribe("/locations/new", function(data){
    alert(data);
  });
});
