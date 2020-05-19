module SessionsHelper
  def sign_in_via_google(user_type)
    link_to 'Sign In with Google', google_omniauth_path(user_type: user_type), method: :get, class: 'has-text-primary'
  end

  def cancel_button(path)
    link_to 'Cancel', path, class: 'button is-dark'
  end
end
