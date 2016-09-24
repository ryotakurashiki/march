$(document).on 'turbolinks:load', ->
  signup_bar = $('#signup-bar')
  $(window).scroll( ->
    if ($(this).scrollTop() > 50)
        signup_bar.slideUp()
    else
      signup_bar.slideDown()
  )
