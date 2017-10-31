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
    content_tag(:div) do
      errors = form.object.errors[key]
      concat form.label(key, {:class => 'uk-form-label'}.merge(label_config))
      concat(content_tag(:div, class: 'uk-form-controls') do
        block.call key, ('uk-form-danger' if errors.any?), form.object.class.human_attribute_name(key)
        if errors.any?
          concat content_tag(:span, errors.join(', '), class: 'uk-text-danger')
        end
      end)
    end
  end
end
