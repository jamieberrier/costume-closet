module ApplicationHelper
  def register_with_email_button(user_type)
    link_to 'Register with email', register_path(user_type: user_type), class: 'heading is-size-6 has-text-white'
  end

  def register_via_google_button(user_type)
    link_to 'Register via Google', google_omniauth_path(user_type: user_type), class: 'heading is-size-6 has-text-white'
  end

  def sign_in_button(user_type)
    link_to "Sign In As A #{user_type.gsub(/_/, ' ')}", login_path(user_type: user_type), class: 'button is-primary is-outlined'
  end
end
