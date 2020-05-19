module CostumesHelper
  # return true if @costume has no rows w/ 2020 dance season in CostumeAssignments table
  def unassigned?
    current_user.unassigned_studio_costumes.include?(@costume)
  end

  def set_costume_path(costume, season)
    season ? costume_path(costume, season: season) : costume_path(costume)
  end

  def show_costume(costume, path)
    if !costume.picture.blank?
      link_to image_tag(costume.picture, width: 100), path
    elsif !costume.onepiece_description.blank?
      link_to costume.onepiece_description, path
    else
      link_to costume.twopiece_description, path
    end
  end
end
