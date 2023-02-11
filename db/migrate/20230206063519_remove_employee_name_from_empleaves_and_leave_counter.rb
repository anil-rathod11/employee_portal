class RemoveEmployeeNameFromEmpleavesAndLeaveCounter < ActiveRecord::Migration[7.0]
  def change
    remove_column :leave_counters, :employee_name
    remove_column :empleaves, :employee_name
  end
end
