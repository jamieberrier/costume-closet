class RemoveBirthdateAndPhonenumberFromDancers < ActiveRecord::Migration[6.0]
  def change
    remove_column :dancers, :birthdate
    remove_column :dancers, :phone_number
  end
end
