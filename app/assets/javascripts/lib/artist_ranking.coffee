$(document).on 'turbolinks:load', ->
  $(".artist-ranking").on('click','tbody .more', ->
    $('.artist-ranking tbody .ranking-item.hidden').slice(0,10).removeClass("hidden").fadeIn()
    if !$(".artist-ranking tbody .ranking-item.hidden")[0]
      $(this).addClass("hidden")
  )
