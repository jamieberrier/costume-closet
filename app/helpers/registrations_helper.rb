module RegistrationsHelper
  def create_empty_user
    if request.env["REQUEST_PATH"].include?("dance_studio")
      @dance_studio = DanceStudio.new
    else
      @dancer = Dancer.new
    end
  end

  def signing_up_as_dance_studio?
    !!params[:dance_studio]
  end

  def signing_up_as_dancer?
    !!params[:dancer]
  end

  def redirect_if_signup_failure(user)
    if signing_up_as_dance_studio?
      return redirect_to register_dance_studio_path, danger: "Signup failure: #{user.errors.full_messages.to_sentence}" unless user.save
    else
      return redirect_to register_dancer_path, danger: "Signup failure: #{user.errors.full_messages.to_sentence}" unless user.save
    end
  end
end
