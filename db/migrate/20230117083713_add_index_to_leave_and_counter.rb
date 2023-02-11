class AddIndexToLeaveAndCounter < ActiveRecord::Migration[7.0]
  def change
    add_index :empleaves, [:employee_id, :start_date], unique: true
    add_index :leave_counters, [:employee_id, :year], unique: true
  end
end
