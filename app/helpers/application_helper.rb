module ApplicationHelper
  def default_meta_tags
   {
      site: Settings.site.name,
      reverse: true,
      title: Settings.site.page_title,
      description: Settings.site.page_description,
      keywords: Settings.site.page_keywords,
      canonical: request.original_url,
      og: {
        title: :title,
        type: Settings.site.meta.ogp.type,
        url: request.original_url,
        image: image_url("social/otolog_fb_ogp.png"),
        #image: image_url(Settings.site.meta.ogp.image_path),
        site_name: Settings.site.name,
        description: :description,
        locale: 'ja_JP'
      },
      fb: {
        admins: 100004211040164
      },
      twitter: {
        site: '@OTOLOG_official',
        card: 'photo',
        image: image_url("social/otolog_tw_card.png"),
        creator: '@OTOLOG_official'
      }
    }
  end

  def controller_classes
    "#{controller_path.gsub('/', ' ')} #{action_name}"
  end

  def jp_date(date)
    date.strftime("%y/%m/%d(#{%w(日 月 火 水 木 金 土)[date.wday]})")
  end

end
