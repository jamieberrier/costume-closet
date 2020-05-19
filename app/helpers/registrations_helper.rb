module RegistrationsHelper
  def field_error_explaination(user, field)
    user.errors.full_messages_for(field).to_sentence
  end
end
