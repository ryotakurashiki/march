$("#create-artist-success-msg").fadeIn();
var artist_name = $('#artist_name').val();
$('#artist_name').val("");
$('#artist-search').val(artist_name)
var evt = $.Event('keydown');
$('#artist-search').trigger(evt);

setTimeout(function() {
  $("#create-artist-success-msg").fadeOut();
}, 1000);
