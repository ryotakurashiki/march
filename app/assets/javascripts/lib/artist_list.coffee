$(document).on 'turbolinks:load', ->
  $('.artist-list').on("ajax:error", ".favorite a" , (event, jqXHR, ajaxSettings, thrownError) ->
    if jqXHR.status == 401 # thrownError is 'Unauthorized'
      #window.location.replace('/users/sign_in')
      $('html,body').animate({scrollTop:0},'fast')
      if $(".alert-danger").length == 0
        $('.main-container').prepend('<div class="alert alert-danger">ログインしてください</div>')
  )
