class RemoveDanceStudioIdToCostumeAssignments < ActiveRecord::Migration[6.0]
  def change
    remove_column :costume_assignments, :dance_studio_id
  end
end
