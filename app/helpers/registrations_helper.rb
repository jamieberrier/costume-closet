module RegistrationsHelper
  # form_for validation errors
  def any_validation_errors?(object_type)
    object_type.errors.any?
  end

  def error_count(object_type)
    pluralize(object_type.errors.count, 'error')
  end

  def any_field_errors?(object_type, field)
    object_type.errors[field].any?
  end

  def field_error_explaination(object_type, field)
    object_type.errors.full_messages_for(field).to_sentence.downcase
  end
end
