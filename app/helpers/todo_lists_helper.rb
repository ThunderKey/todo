module TodoListsHelper
  def section_title_to_class title
    cls = if title.nil?
      :warning
    elsif title.is_a? Symbol
      case title&.to_sym
        when :past; :danger
        when :not_planned; :warning
      end
    else
      nil
    end

    cls ? "section-#{cls}" : nil
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
