class CreateCostumeAssignments < ActiveRecord::Migration[6.0]
  def change
    create_table :costume_assignments do |t|
      t.integer :dancer_id
      t.integer :costume_id
      t.string :costume_condition
      t.string :costume_size
      t.string :song_name
      t.string :dance_season
      t.string :genre
      t.string :shoe
      t.string :tight

      t.timestamps
    end
  end
end
