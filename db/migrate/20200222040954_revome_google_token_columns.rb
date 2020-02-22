class RevomeGoogleTokenColumns < ActiveRecord::Migration[6.0]
  def change
    remove_column :dance_studios, :google_token
    remove_column :dance_studios, :google_refresh_token
  end
end
