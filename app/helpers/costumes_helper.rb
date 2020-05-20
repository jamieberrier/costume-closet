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

  def assign_costume_button(costume)
    # if previously assigned, pass the last season the costume was assigned
    link_to_if costume.seasons.empty?, 'Assign Costume', assign_costume_path(costume), class: 'button is-success is-light' do |name|
      link_to name, assign_costume_path(costume, season: costume.seasons.to_a.pop[0]), class: 'button is-success is-light'
    end
  end

  def view_costume_assignments_button(costume)
    if params[:season]
      link_to "View #{current_year} Costume Assignments", season_assignments_path(costume, season: current_year), class: 'button is-primary'
    else
      link_to 'View All Costume Assignments', assigned_costume_path(costume), class: 'button is-primary'
    end
  end

  def costume_seasons(costume)
    costume.seasons
  end

  def collecting_shared_info?(assignment_builder)
    assignment_builder.object.dancer_id.nil?
  end

  def collecting_dancer_info?(assignment_builder)
    !assignment_builder.object.dancer_id.nil? && assignment_builder.object.dance_season.nil?
  end

  def displaying_assigned_dancers?(assignment_builder)
    !assignment_builder.object.dancer_id.nil? && assignment_builder.object.dance_season == @season
  end

  def adding_dancers?(assignment_builder)
    assignment_builder.object.dance_season.nil?
  end
end
