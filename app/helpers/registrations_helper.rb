module RegistrationsHelper
  # form_for validation errors
  def any_validation_errors?(user_type)
    user_type.errors.any?
  end

  def error_count(user_type)
    pluralize(user_type.errors.count, 'error')
  end

  def any_field_errors?(user_type, field)
    user_type.errors[field].any?
  end

  def field_error_explaination(user_type, field)
    user_type.errors.full_messages_for(field).to_sentence.downcase
  end
end
