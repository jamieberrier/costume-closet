class RemoveDefaultValueFromHairAccessory < ActiveRecord::Migration[6.0]
  def change
    change_column_default :costumes, :hair_accessory, nil
  end
end
