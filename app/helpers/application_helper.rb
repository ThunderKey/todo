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
end
