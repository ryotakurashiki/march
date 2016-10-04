$(document).on 'turbolinks:load', ->
  signup_bar = $('header nav #signup-bar')
  $(window).scroll( ->
    if ($(this).scrollTop() > 40)
        signup_bar.slideUp()
    else
      signup_bar.slideDown()
  )
