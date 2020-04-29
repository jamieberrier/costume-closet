module DancersHelper
  def find_dancer
    @dancer = Dancer.find(params[:id])
  end

  def render_new_form
    flash.now[:danger] = "Signup failure: #{@dancer.errors.full_messages.to_sentence}"

    render 'dancers/new'
  end

  def render_registration_form
    flash.now[:danger] = "Signup failure: #{@dancer.errors.full_messages.to_sentence}"

    render 'registrations/new'
  end

  def render_edit_form
    flash.now[:danger] = "Signup failure: #{@dancer.errors.full_messages.to_sentence}"

    render 'dancers/edit'
  end
end
