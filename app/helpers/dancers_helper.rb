module DancersHelper
  def picture_link_to_costume_path(costume)
    link_to image_tag(costume.picture, width: 100), costume_path(costume)
  end

  def onepiece_link_to_costume_path(costume)
    link_to costume.onepiece_description, costume_path(costume)
  end

  def twopiece_link_to_costume_path(costume)
    link_to costume.twopiece_description, costume_path(costume)
  end

  def assignment_costume(assignment)
    Costume.find(assignment.costume_id)
  end
end
