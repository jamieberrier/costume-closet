class CreateDancers < ActiveRecord::Migration[6.0]
  def change
    create_table :dancers do |t|
      t.string :first_name
      t.string :last_name
      t.date :birthdate
      t.string :email
      t.string :phone_number
      t.boolean :current_dancer, :default => true
      t.integer :dance_studio_id

      t.timestamps
    end
  end
end
