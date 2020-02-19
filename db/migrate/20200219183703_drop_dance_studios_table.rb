class DropDanceStudiosTable < ActiveRecord::Migration[6.0]
  def change
    drop_table :dance_studios
  end
end
