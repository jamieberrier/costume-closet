module CostumesHelper
  # return true if @costume has no rows w/ 2020 dance season in CostumeAssignments table
  def unassigned?
    current_user.unassigned_studio_costumes.include?(@costume)
  end
end
