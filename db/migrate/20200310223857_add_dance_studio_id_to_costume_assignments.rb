class AddDanceStudioIdToCostumeAssignments < ActiveRecord::Migration[6.0]
  def change
    add_column :costume_assignments, :dance_studio_id, :integer
  end
end
