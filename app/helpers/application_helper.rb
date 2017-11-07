module ApplicationHelper
  def translate_flash_type type
    type = type.to_sym
    cls = case type
      when :notice; :primary
      when :error, :alert;  :danger
      else type
    end
    "uk-alert-#{cls}"
  end

  def form_field form, key, label_config: {}, &block
    errors = form.object.errors[key]
    content_tag(:div, class: 'form-row', 'uk-grid' => '') do
      concat(content_tag(:div, class: 'form-label') do
        form.label(key, {:class => "uk-form-label #{'uk-text-danger' if errors.any?}"}.merge(label_config))
      end)
      concat(content_tag(:div, class: 'form-field uk-form-controls') do
        block.call key, ('uk-form-danger' if errors.any?), form.object.class.human_attribute_name(key)
        if errors.any?
          concat content_tag(:span, errors.join(', '), class: 'uk-text-danger')
        end
      end)
    end
  end

  def grouped_column_classes count
    classes = 'uk-child-width-1-1'
    return classes if count < 2
    classes = "#{classes} uk-child-width-1-2@s"
    return classes if count < 4
    classes = "#{classes} uk-child-width-1-4@m"
  end

  def grouped_sub_column_classes count
    classes = 'uk-child-width-1-1'
    return "#{classes} uk-child-width-1-2@xl" if count >= 4
    return "#{classes} uk-child-width-1-2@l uk-child-width-1-4@xl" if count >= 2
    "#{classes} uk-child-width-1-2@2 uk-child-width-1-4@m uk-child-width-1-5@l uk-child-width-1-6@xl"
  end
end
