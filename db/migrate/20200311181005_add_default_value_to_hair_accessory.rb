class AddDefaultValueToHairAccessory < ActiveRecord::Migration[6.0]
  def change
    change_column_default :costumes, :hair_accessory, 'none'
  end
end
