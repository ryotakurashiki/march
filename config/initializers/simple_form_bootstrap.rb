inputs = %w[
  CollectionSelectInput
  DateTimeInput
  FileInput
  GroupedCollectionSelectInput
  NumericInput
  PasswordInput
  RangeInput
  StringInput
  TextInput
]

inputs.each do |input_type|
  superclass = "SimpleForm::Inputs::#{input_type}".constantize

  new_class = Class.new(superclass) do
    def input_html_classes
      super.push('form-control')
    end
  end

  Object.const_set(input_type, new_class)
end

# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.boolean_style = :nested

  config.wrappers :bootstrap3, tag: 'div', class: 'form-group', error_class: 'has-error',
      defaults: { input_html: { class: 'default_class' } } do |b|

    b.use :html5
    b.use :min_max
    b.use :maxlength
    b.use :placeholder

    b.optional :pattern
    b.optional :readonly

    b.use :label_input
    b.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
    b.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
  end

  config.wrappers :prepend, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-group' do |prepend|
    prepend.use :label , class: 'input-group-addon' ###Please note setting class here fro the label does not currently work (let me know if you know a workaround as this is the final hurdle)
        prepend.use :input
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
    end
  end

  config.wrappers :append, tag: 'div', class: 'form-group', error_class: 'has-error' do |b|
    b.use :html5
    b.use :placeholder
    b.wrapper tag: 'div', class: 'controls' do |input|
      input.wrapper tag: 'div', class: 'input-group' do |prepend|
        prepend.use :input
    prepend.use :label , class: 'input-group-addon' ###Please note setting class here fro the label does not currently work (let me know if you know a workaround as this is the final hurdle)
      end
      input.use :hint,  wrap_with: { tag: 'span', class: 'help-block' }
      input.use :error, wrap_with: { tag: 'span', class: 'help-block has-error' }
    end
  end

  config.wrappers :horizontal_input_group, tag: :div, class: "form-group", error_class: "has-error" do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: "col-sm-3 col-xs-12 control-label"

    b.wrapper tag: :div, class: "col-sm-9" do |ba|
      ba.wrapper tag: :div, class: "input-group col-sm-12 col-xs-12" do |append|
        append.use :input, class: "form-control"
      end
      ba.use :error, wrap_with: { tag: "span", class: "help-block" }
      ba.use :hint, wrap_with: { tag: "p", class: "help-block" }
    end
  end

  config.wrappers :horizontal_date_picker, tag: :div, class: "form-group", error_class: "has-error" do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: "col-sm-3 control-label"

    b.wrapper tag: :div, class: "col-sm-9" do |ba|
      ba.wrapper tag: :div, class: "input-group col-sm-12" do |append|
        append.use :input, class: "form-control datetimepicker", data: { date_format: "YYYY/MM/DD" }
      end
      ba.use :error, wrap_with: { tag: "span", class: "help-block" }
      ba.use :hint, wrap_with: { tag: "p", class: "help-block" }
    end
  end
  config.wrappers :horizontal_datetime_picker, tag: :div, class: "form-group", error_class: "has-error" do |b|
    b.use :html5
    b.use :placeholder
    b.use :label, class: "col-sm-3 control-label"

    b.wrapper tag: :div, class: "col-sm-9" do |ba|
      ba.wrapper tag: :div, class: "input-group col-sm-12" do |append|
        append.use :input, class: "form-control datetimepicker", data: { date_format: "YYYY/MM/DD HH:00" }
      end
      ba.use :error, wrap_with: { tag: "span", class: "help-block" }
      ba.use :hint, wrap_with: { tag: "p", class: "help-block" }
    end
  end
  config.wrappers :horizontal_boolean, tag: :div, class: "form-group", error_class: "has-error" do |b|
    b.use :label, class: "col-sm-3 control-label"

    b.wrapper tag: :div, class: "col-sm-9" do |ba|
      ba.wrapper tag: :div, class: "input-group col-sm-12" do |append|
        append.use :input
      end
      ba.use :error, wrap_with: { tag: "span", class: "help-block" }
      ba.use :hint,  wrap_with: { tag: "p", class: "help-block" }
    end
  end

  config.wrappers :horizontal_radio_and_checkboxes, tag: :div, class: "form-group", error_class: "has-error" do |b|
    b.use :html5
    b.optional :readonly

    b.use :label, class: "col-sm-3 control-label"

    b.wrapper tag: :div, class: "col-sm-9" do |ba|
      ba.use :input
      ba.use :error, wrap_with: { tag: :span, class: "help-block" }
      ba.use :hint,  wrap_with: { tag: :p, class: "help-block" }
    end
  end
  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://getbootstrap.com/)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :bootstrap3
end
