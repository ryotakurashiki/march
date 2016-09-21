module ApplicationHelper
  def meta_tag_params
    {:viewport => "width=device-width, initial-scale=1.0"}
  end

  def controller_classes
    "#{controller_path.gsub('/', ' ')} #{action_name}"
  end

  def jp_date(date)
    date.strftime("%y/%m/%d(#{%w(日 月 火 水 木 金 土)[date.wday]})")
  end
end
