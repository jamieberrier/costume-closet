module DanceStudiosHelper
  def find_dance_studio
    @dance_studio = DanceStudio.find(params[:id])
  end
end
