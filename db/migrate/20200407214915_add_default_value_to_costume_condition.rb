class AddDefaultValueToCostumeCondition < ActiveRecord::Migration[6.0]
  def change
    change_column_default :costume_assignments, :costume_condition, 'new'
  end
end
