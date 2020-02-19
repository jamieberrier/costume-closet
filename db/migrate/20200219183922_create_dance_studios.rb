class CreateDanceStudios < ActiveRecord::Migration[6.0]
  def change
    create_table :dance_studios do |t|
      t.string :studio_name
      t.string :owner_name
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
