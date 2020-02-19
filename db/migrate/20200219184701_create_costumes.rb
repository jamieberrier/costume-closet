class CreateCostumes < ActiveRecord::Migration[6.0]
  def change
    create_table :costumes do |t|
      t.text :top_description
      t.text :bottoms_description
      t.text :onepiece_description
      t.string :picture
      t.string :hair_accessory
      t.integer :dance_studio_id

      t.timestamps
    end
  end
end
