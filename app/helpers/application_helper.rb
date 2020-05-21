module ApplicationHelper
  # Home Page Buttons
  def register_with_email_button(user_type)
    link_to 'Register with email', register_path(user_type: user_type), class: 'heading is-size-6 has-text-white'
  end

  def register_via_google_button(user_type)
    link_to 'Register via Google', google_omniauth_path(user_type: user_type), class: 'heading is-size-6 has-text-white'
  end

  def sign_in_button(user_type)
    link_to "Sign In As A #{user_type.gsub(/_/, ' ')}", login_path(user_type: user_type), class: 'button is-primary is-outlined'
  end

  # Navigation Bar Links
  def hanger_link_to_show_view
    link_to_if owner?, image_tag('hanger.svg'), dance_studio_path(current_user) do |name|
      link_to name, dancer_path(current_user)
    end
  end

  def link_to_new_costume
    link_to 'New Costume', new_dance_studio_costume_path(current_user), class: 'has-text-grey-dark'
  end

  def link_to_unassigned_costumes
    link_to 'Unassigned Costumes', unassigned_costumes_path(current_user), class: 'has-text-grey-dark'
  end

  def link_to_current_costume_assignments
    link_to_if owner?, 'Current Season Costumes', studio_current_costumes_path(current_user), class: 'has-text-grey-dark' do |name|
      link_to name, dancer_current_assignments_path(current_user), class: 'has-text-grey-dark'
    end
  end

  def link_to_all_costumes
    link_to_if owner?, 'All Costumes', dance_studio_costumes_path(current_user), class: 'has-text-grey-dark' do |name|
      link_to name, dancer_costumes_path(current_user), class: 'has-text-grey-dark'
    end
  end

  def link_to_log_out
    link_to 'Log Out', logout_path, class: 'has-text-grey-dark', method: :post
  end
end
