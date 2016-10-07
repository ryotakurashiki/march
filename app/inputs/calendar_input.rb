class CalendarInput < SimpleForm::Inputs::Base
  def input(_)
    input_html_classes.push("form-control")
    @builder.date_field(attribute_name, input_html_options).html_safe
  end
end
