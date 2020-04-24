class RemoveHairAccessoryFromCostume < ActiveRecord::Migration[6.0]
  def change
    remove_column :costumes, :hair_accessory
  end
end
