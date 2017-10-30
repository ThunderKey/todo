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
end
