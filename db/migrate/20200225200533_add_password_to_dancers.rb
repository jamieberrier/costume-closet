class AddPasswordToDancers < ActiveRecord::Migration[6.0]
  def change
    add_column :dancers, :password_digest, :string
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
