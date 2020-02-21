class AddGoogleTokensToDanceStudio < ActiveRecord::Migration[6.0]
  def change
    add_column :dance_studios, :google_token, :string
   add_column :dance_studios, :google_refresh_token, :string
  end
end
