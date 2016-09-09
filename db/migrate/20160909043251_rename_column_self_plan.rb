class RenameColumnSelfPlan < ActiveRecord::Migration[5.0]
  def change
    rename_column :concerts, :self_plan, :self_planed
  end
end
