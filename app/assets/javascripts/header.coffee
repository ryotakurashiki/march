$(document).on 'turbolinks:load', ->
  # ヘッダーの高さだけmainをpaddingする
  padding = $("header").height()
  $("#main").css('padding-top', padding)

  # ログインしてないとき、下にスクロールするとログインへの導線を隠す
  signup_bar = $('header nav #signup-bar')
  $(window).scroll( ->
    if ($(this).scrollTop() > 40)
        signup_bar.slideUp()
    else
      signup_bar.slideDown()
  )
