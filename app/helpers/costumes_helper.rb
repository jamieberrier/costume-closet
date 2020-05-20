module CostumesHelper
  # return true if @costume has no rows w/ 2020 dance season in CostumeAssignments table
  def unassigned?
    current_user.unassigned_studio_costumes.include?(@costume)
  end

  def set_costume_path(costume, season)
    season ? costume_path(costume, season: season) : costume_path(costume)
  end

  def costume_picture?(costume)
    costume.picture.present?
  end

  def costume_onepiece_description?(costume)
    costume.onepiece_description.present?
  end

  def show_costume_with_link(costume, path)
    if costume_picture?(costume)
      link_to image_tag(costume.picture, width: 100), path
    elsif costume_onepiece_description?(costume)
      link_to costume.onepiece_description, path
    else
      link_to costume.twopiece_description, path
    end
  end
end
