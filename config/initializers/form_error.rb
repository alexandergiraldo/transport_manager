ActionView::Base.field_error_proc = proc do |html_tag, _instance|
  class_attr_index = html_tag.index 'class="'
  invalid_feedback = %(<div class="invalid-feedback">#{_instance.error_message.uniq.join(', ')}</div>).html_safe

  if class_attr_index
    html_tag.insert class_attr_index + 7, 'is-invalid '
  else
    html_tag.insert html_tag.index('>'), ' class="is-invalid"'
  end

  "#{html_tag+invalid_feedback}".html_safe
end