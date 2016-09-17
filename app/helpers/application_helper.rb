module ApplicationHelper
  def meta_tag_params
    {:viewport => "width=device-width, initial-scale=1.0"}
  end

  def controller_classes
    "#{controller_path.gsub('/', ' ')} #{action_name}"
  end
end
