$(".error-msg").text("そのアーティストは既に存在します").fadeIn();
setTimeout(function() {
  $(".error-msg").fadeOut();
}, 1000);
