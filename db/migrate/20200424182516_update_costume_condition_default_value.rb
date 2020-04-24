class UpdateCostumeConditionDefaultValue < ActiveRecord::Migration[6.0]
  def change
    change_column_default :costume_assignments, :costume_condition, 'New'
  end
end
